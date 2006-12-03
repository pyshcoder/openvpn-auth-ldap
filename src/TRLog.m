/*
 * TRLog.m
 * Simple logging interface
 *
 * Author: Landon Fuller <landonf@threerings.net>
 *
 * Copyright (c) 2006 Three Rings Design, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holder nor the names of any contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <syslog.h>
#include <stdio.h>
#include <stdarg.h>

#include "TRLog.h"

static BOOL _quiesce = NO;

#define DO_LOG(logName, priority) \
	+ (void) logName: (const char *) message, ... { \
		va_list ap; \
		if (_quiesce) return; \
		va_start(ap, message); \
		vsyslog(priority, message, ap); \
		va_end(ap); \
		va_start(ap, message); \
		vfprintf(stderr, message, ap); \
		va_end(ap); \
		fprintf(stderr, "\n"); \
	}

@implementation TRLog

/*!
 * Private method that quiets all logging for the purpose of unit testing.
 */
+ (void) _quiesceLogging: (BOOL) quiesce {
	_quiesce = quiesce;
}

DO_LOG(error, LOG_ERR);
DO_LOG(warning, LOG_WARNING);
DO_LOG(info, LOG_INFO);
DO_LOG(debug, LOG_DEBUG);

@end
