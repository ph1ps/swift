//===-- FeatureParsingTest.cpp ----------------------------------*- C++ -*-===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2025 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "FeatureParsingTest.h"

using namespace swift;

const std::string FeatureParsingTest::defaultLangMode = "5";

FeatureParsingTest::FeatureParsingTest() : ArgParsingTest() {
  this->langMode = defaultLangMode;
}

FeatureWrapper::FeatureWrapper(Feature id)
    : id(id), name(getFeatureName(id).data()) {
  auto langMode = getFeatureLanguageVersion(id);
  if (langMode) {
    this->langMode = std::to_string(*langMode);
  }
}

void swift::PrintTo(const StrictConcurrency &value, std::ostream *os) {
  switch (value) {
  case StrictConcurrency::Minimal:
    *os << "Minimal";
    break;
  case StrictConcurrency::Targeted:
    *os << "Targeted";
    break;
  case StrictConcurrency::Complete:
    *os << "Complete";
    break;
  }
}
