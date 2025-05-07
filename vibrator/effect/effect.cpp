/*
 * Copyright (c) 2020, The Linux Foundation. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 *       copyright notice, this list of conditions and the following
 *       disclaimer in the documentation and/or other materials provided
 *       with the distribution.
 *     * Neither the name of The Linux Foundation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
 * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
 * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Changes from Qualcomm Innovation Center are provided under the following license:
 * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause-Clear
 */

#include "effect.h"

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(*(a)))

#include "generated_effect.h"
#include <android-base/properties.h>
#include <string>

static const int8_t primitive_0[] = {
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
};

static const int8_t primitive_1[] = {
    17,  34,  50,  65,  79,  92,  103, 112, 119, 124,
    127, 127, 126, 122, 116, 108, 98,  86,  73,  58,
    42,  26,  9,   -8,  -25, -41, -57, -72, -85, -97,
    -108, -116, -122, -126, -127, -127, -125, -120,
    -113, -104, -93,  -80, -66, -51, -35, -18, -1,
};

static const int8_t primitive_1_gentle[] = {
     0,  10,  16,  22,  28,  33,  38,  43,  47,  51,
    55,  59,  62,  65,  68,  71,  73,  75,  77,  78,
    79,  80,  80,  80,  80,  79,  78,  77,  75,  73,
    71,  68,  65,  62,  59,  55,  51,  47,  43,  38,
    33,  28,  22,  16,  10,   5,   0,  -5, -10
};

static const struct effect_stream primitives[] = {
    {
        .effect_id = 0,
        .length = ARRAY_SIZE(primitive_0),
        .play_rate_hz = 8000,
        .data = primitive_0,
    },

    {
        .effect_id = 1,
        .length = ARRAY_SIZE(primitive_1),
        .play_rate_hz = 8000,
        .data = primitive_1,
    },

    {
        .effect_id = 2,
        .length = ARRAY_SIZE(primitive_1),
        .play_rate_hz = 8000,
        .data = primitive_1,
    },
};

static const struct effect_stream primitives_gentle[] = {
    {
        .effect_id = 0,
        .length = ARRAY_SIZE(primitive_0),
        .play_rate_hz = 8000,
        .data = primitive_0,
    },

    {
        .effect_id = 1,
        .length = ARRAY_SIZE(primitive_1_gentle),
        .play_rate_hz = 8000,
        .data = primitive_1_gentle,
    },

    {
        .effect_id = 2,
        .length = ARRAY_SIZE(primitive_1_gentle),
        .play_rate_hz = 8000,
        .data = primitive_1_gentle,
    },
};

const struct effect_stream* find_effect(const struct effect_stream* arr, size_t size, uint32_t effect_id) {
    for (size_t i = 0; i < size; ++i) {
        if (effect_id == arr[i].effect_id)
            return &arr[i];
    }
    return NULL;
}

const struct effect_stream* get_effect_stream(uint32_t effect_id) {
    using android::base::GetProperty;
    const struct effect_stream *selected_effects = effects;
    size_t effects_size = ARRAY_SIZE(effects);
    std::string profile = GetProperty("persist.vendor.haptic_profile", "richtap");

    if ((effect_id & 0x8000) != 0) {
        effect_id &= 0x7fff;
        if (profile == "gentle") {
            return find_effect(primitives_gentle, ARRAY_SIZE(primitives_gentle), effect_id);
        } else {
            return find_effect(primitives, ARRAY_SIZE(primitives), effect_id);
        }
    }

    if (profile == "crisp") {
        selected_effects = effects_crisp;
        effects_size = ARRAY_SIZE(effects_crisp);
    } else if (profile == "gentle") {
        selected_effects = effects_gentle;
        effects_size = ARRAY_SIZE(effects_gentle);
    }

    return find_effect(selected_effects, effects_size, effect_id);
}
