/*
 *  SKStructs.h
 *  SaneKit
 *
 *  Created by MK on 03.09.11.
 *  Copyright 2011 __MyCompanyName__. All rights reserved.
 *
 */

/**
 * This header includes struct definitions which encapsulate Sane
 * datatypes so that no Sane headers are necessary for using the
 * SK* classes.
 */
#include <sane/sane.h>

struct SaneHandle {
    SANE_Handle deviceHandle;
};