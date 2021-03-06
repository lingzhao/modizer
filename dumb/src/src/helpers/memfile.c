/*  _______         ____    __         ___    ___
 * \    _  \       \    /  \  /       \   \  /   /       '   '  '
 *  |  | \  \       |  |    ||         |   \/   |         .      .
 *  |  |  |  |      |  |    ||         ||\  /|  |
 *  |  |  |  |      |  |    ||         || \/ |  |         '  '  '
 *  |  |  |  |      |  |    ||         ||    |  |         .      .
 *  |  |_/  /        \  \__//          ||    |  |
 * /_______/ynamic    \____/niversal  /__\  /____\usic   /|  .  . ibliotheque
 *                                                      /  \
 *                                                     / .  \
 * memfile.c - Module for reading data from           / / \  \
 *             memory using a DUMBFILE.              | <  /   \_
 *                                                   |  \/ /\   /
 * By entheh.                                         \_  /  > /
 *                                                      | \ / /
 *                                                      |  ' /
 *                                                       \__/
 */

#include <stdlib.h>
#include <string.h>

#include "dumb.h"



typedef struct MEMFILE MEMFILE;

struct MEMFILE
{
	const char *ptr, *ptr_begin;
	long left, size;
};

struct DUMBFILE
{
	const DUMBFILE_SYSTEM *dfs;
	void *file;
	long pos;
};

static DUMBFILE *mem_dumbfile;

static int dumb_memfile_skip(void *f, long n)
{
	MEMFILE *m = (MEMFILE *)(mem_dumbfile->file);
	if (n > m->left) return -1;
	m->ptr += n;
	m->left -= n;
	return 0;
}



static int dumb_memfile_getc(void *f)
{
	MEMFILE *m = (MEMFILE *)(mem_dumbfile->file);
	if (m->left <= 0) return -1;
	m->left--;
	return *(const unsigned char *)m->ptr++;
}



static long dumb_memfile_getnc(char *ptr, long n, void *f)
{
	MEMFILE *m = (MEMFILE *)(mem_dumbfile->file);
	if (n > m->left) n = m->left;
	memcpy(ptr, m->ptr, n);
	m->ptr += n;
	m->left -= n;
	return n;
}



static void dumb_memfile_close(void *f)
{
    MEMFILE *m = (MEMFILE *)(mem_dumbfile->file);
	free(m);
    free(mem_dumbfile);
}

static void *dumb_memfile_open(const char *filename)
{
	return mem_dumbfile;
}

static int dumb_memfile_seek(void *f, long n)
{
	MEMFILE *m = (MEMFILE *)(mem_dumbfile->file);
    
	m->ptr = m->ptr_begin + n;
	m->left = m->size - n;
    
	return 0;
}


static long dumb_memfile_get_size(void *f)
{
	MEMFILE *m = (MEMFILE *)(mem_dumbfile->file);
	return m->size;
}

static const DUMBFILE_SYSTEM memfile_dfs = {
	&dumb_memfile_open,
	&dumb_memfile_skip,
	&dumb_memfile_getc,
	&dumb_memfile_getnc,
	&dumb_memfile_close,
    &dumb_memfile_seek,
	&dumb_memfile_get_size

};

void dumb_register_memfiles(void)
{
	register_dumbfile_system(&memfile_dfs);
}


DUMBFILE *dumbfile_open_memory(const char *data, long size)
{
	MEMFILE *m = malloc(sizeof(*m));
	if (!m) return NULL;

    m->ptr_begin = data;
	m->ptr = data;
	m->left = size;
    m->size = size;
    
    mem_dumbfile=dumbfile_open_ex(m, &memfile_dfs);
	return mem_dumbfile;
}
