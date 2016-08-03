#include <string.h>
#include <unistd.h>
#include <limits.h>
#include "sass.h"
#include <stdio.h>
#include "erl_nif.h"

static inline ERL_NIF_TERM make_atom(ErlNifEnv* env, const char* name)
{
  ERL_NIF_TERM ret;
  if(enif_make_existing_atom(env, name, &ret, ERL_NIF_LATIN1)) {
    return ret;
  }
  return enif_make_atom(env, name);
}

static inline ERL_NIF_TERM make_tuple(ErlNifEnv* env, const char* mesg, const char* atom_string)
{
  int output_len = sizeof(char) * strlen(mesg);
  ErlNifBinary output_binary;
  enif_alloc_binary(output_len, &output_binary);
  strncpy((char*)output_binary.data, mesg, output_len);
  ERL_NIF_TERM atom = make_atom(env, atom_string);
  ERL_NIF_TERM str = enif_make_binary(env, &output_binary);
  return enif_make_tuple2(env, atom, str);
}


char* utf8cpy(char* dst, const char* src, size_t sizeDest )
{
	if( sizeDest ){
		size_t sizeSrc = strlen(src); // number of bytes not including null
		while( sizeSrc >= sizeDest ){

			const char* lastByte = src + sizeSrc; // Initially, pointing to the null terminator.
			while( lastByte-- > src )
				if((*lastByte & 0xC0) != 0x80) // Found the initial byte of the (potentially) multi-byte character (or found null).
					break;

			sizeSrc = lastByte - src;
		}
		memcpy(dst, src, sizeSrc);
		dst[sizeSrc] = '\0';
	}
	return dst;
}


static int my_enif_list_size(ErlNifEnv* env, ERL_NIF_TERM list)
{
  ERL_NIF_TERM head, tail, nexttail;
  int size = 0;
  tail = list;
  while(enif_get_list_cell(env, tail, &head, &nexttail))
  {
    tail = nexttail;
    size = size+1;
  }
  return size;
}

static char* my_enif_get_string(ErlNifEnv *env, ERL_NIF_TERM list)
{
  char *buf;
  int size=my_enif_list_size(env, list);

  if (!(buf = (char*) enif_alloc(size+1)))
  {
    return NULL;
  }
  if (enif_get_string(env, list, buf, size+1, ERL_NIF_LATIN1)<1)
  {
    enif_free(buf);
    return NULL;
  }
  return buf;
}

static ERL_NIF_TERM sass_compile_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  ErlNifBinary input_binary;
  ERL_NIF_TERM ret;

  if (argc != 1) {
    return enif_make_badarg(env);
  }
  char* sass_string = malloc(my_enif_list_size(env, argv[0]));
  memcpy(sass_string, my_enif_get_string(env, argv[0]), my_enif_list_size(env, argv[0]) + 2);

  if(!sass_string) {
    return enif_make_badarg(env);
  }

  struct Sass_Data_Context* ctx = sass_make_data_context(sass_string);

  struct Sass_Context* ctx_out = sass_data_context_get_context(ctx);
  struct Sass_Options* options = sass_context_get_options(ctx_out);

  sass_option_set_output_style(options, SASS_STYLE_NESTED);
  sass_option_set_precision(options, 5);
  sass_data_context_set_options(ctx, options);


  sass_compile_data_context(ctx);

  int error_status = sass_context_get_error_status(ctx_out);
  const char *error_message = sass_context_get_error_message(ctx_out);
  const char *output_string = sass_context_take_output_string(ctx_out);

  if (error_status) {
    if (error_message) {
      ret = make_tuple(env, error_message, "error");
    } else {
      ret = make_tuple(env, "An error occured; no error message available.", "error");
    }
  } else if (output_string) {
    ret = make_tuple(env, output_string, "ok");
  } else {
    ret = make_tuple(env, "Unknown internal error.", "error");
  }
  sass_delete_data_context(ctx);

  return ret;
}

/*static ERL_NIF_TERM sass_compile_file_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])*/
/*{*/
  /*ErlNifBinary input_binary;*/
  /*ERL_NIF_TERM ret;*/

  /*if (argc != 1) {*/
    /*return enif_make_badarg(env);*/
  /*}*/

  /*if(!enif_inspect_binary(env, argv[0], &input_binary)){*/
    /*return enif_make_badarg(env);*/
  /*}*/

  /*char directory[PATH_MAX];*/
  /*getcwd(directory, sizeof(directory));*/

  /*char * path = malloc(strlen(directory) + strlen((char*)input_binary.data) + 2);*/
  /*strcpy(path, directory);*/
  /*strcat(path, "/");*/
  /*strcat(path, (char*)input_binary.data);*/

  /*struct sass_file_context* ctx = sass_new_file_context();*/
  /*ctx->options.include_paths = "";*/
  /*ctx->options.output_style = SASS_STYLE_NESTED;*/
  /*ctx->input_path = path;*/

  /*sass_compile_file(ctx);*/
  /*if (ctx->error_status) {*/
    /*if (ctx->error_message) {*/
      /*ret = make_tuple(env, ctx->error_message, "error");*/
    /*} else {*/
      /*ret = make_tuple(env, "An error occured; no error message available.", "error");*/
    /*}*/
  /*} else if (ctx->output_string) {*/
    /*ret = make_tuple(env, ctx->output_string, "ok");*/
  /*} else {*/
    /*ret = make_tuple(env, "Unknown internal error.", "error");*/
  /*}*/
  /*sass_free_file_context(ctx);*/

  /*return ret;*/
/*}*/

static int on_load(ErlNifEnv* env, void** priv_data, ERL_NIF_TERM load_info)
{
  return 0;
}

static ErlNifFunc nif_funcs[] = {
  { "compile", 1, sass_compile_nif },
  /*{ "compile_file", 1, sass_compile_file_nif },*/
};

ERL_NIF_INIT(Elixir.Sass.Compiler, nif_funcs, NULL, NULL, NULL, NULL);
