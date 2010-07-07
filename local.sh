#!/bin/sh

MATH_2D_SOURCE="../math_2d/"

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

extract()
{
  search="$1"
  file_i="$2"
  file_o="src/$3"

  grep -h "${search}" "${file_i}" > "${file_o}.tmp" ||
    fatal "could not extract type"
  cat "${file_o}.tmp" | sed -E 's/ +/ /g' | sed 's/^ //g' > "${file_o}.tmp.tmp" ||
    fatal "could not collapse space"
  mv "${file_o}.tmp.tmp" "${file_o}.tmp" ||
    fatal "could not rename ${file_o}.tmp.tmp"
  mv "${file_o}.tmp" "${file_o}" ||
    fatal "could not rename ${file_o}.tmp"
}

extract_range()
{
  pattern_start="$1"
  pattern_end="$2"
  file_i="$3"
  file_o="src/$4"

  ./grep-range "${pattern_start}" "${pattern_end}" < "${file_i}" > "${file_o}.tmp" ||
    fatal "could not extract range"
  mv "${file_o}.tmp" "${file_o}" ||
    fatal "could not rename ${file_o}.tmp ${file_o}"

  trim_leading_space "${file_o}" "$4"
}

extract_range_exclusive()
{
  pattern_start="$1"
  pattern_end="$2"
  file_i="$3"
  file_o="src/$4"

  ./grep-range "${pattern_start}" "${pattern_end}" < "${file_i}" | sed -n '$!p' > "${file_o}.tmp" ||
    fatal "could not extract range"
  mv "${file_o}.tmp" "${file_o}" ||
    fatal "could not rename ${file_o}.tmp ${file_o}"
}

trim_leading_space()
{
  file_i="$1"
  file_o="src/$2"

  sed 's/^  //' < "${file_i}" > "${file_o}.tmp" ||
    fatal "could not remove leading whitespace"
  mv "${file_o}.tmp" "${file_o}" ||
    fatal "could not rename ${file_o}"
}

extract 'type Degrees_t'      "${MATH_2D_SOURCE}/math_2d-trigonometry.ads" "math_2d-trigonometry-degrees_t.txt"
extract 'type Line_Segment_t' "${MATH_2D_SOURCE}/math_2d-types.ads"        "math_2d-types-line_segment_t.txt"
extract 'type Point_t'        "${MATH_2D_SOURCE}/math_2d-types.ads"        "math_2d-types-point_t.txt"
extract 'type Radians_t'      "${MATH_2D_SOURCE}/math_2d-trigonometry.ads" "math_2d-trigonometry-radians_t.txt"
extract 'type Triangle_t'     "${MATH_2D_SOURCE}/math_2d-types.ads"        "math_2d-types-triangle_t.txt"

extract_range "function Area"            "return" "${MATH_2D_SOURCE}/math_2d-triangles.ads" "math_2d-triangles-area.txt"
extract_range "function Orthocenter"     "return" "${MATH_2D_SOURCE}/math_2d-triangles.ads" "math_2d-triangles-orthocenter.txt"
extract_range "function Perimeter"       "return" "${MATH_2D_SOURCE}/math_2d-triangles.ads" "math_2d-triangles-perimeter.txt"
extract_range "function Point_Is_Inside" "return" "${MATH_2D_SOURCE}/math_2d-triangles.ads" "math_2d-triangles-point_is_inside.txt"
extract_range "function Distance"        "return" "${MATH_2D_SOURCE}/math_2d-points.ads" "math_2d-points-distance.txt"
extract_range "function To_Radians"      "return" "${MATH_2D_SOURCE}/math_2d-trigonometry.ads" "math_2d-trigonometry-to_radians.txt"
extract_range "function To_Degrees"      "return" "${MATH_2D_SOURCE}/math_2d-trigonometry.ads" "math_2d-trigonometry-to_degrees.txt"

extract_range "function Inner_Product"    "renames" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-inner_product.txt"
extract_range "function Scalar_Product"   "renames" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-scalar_product.txt"
extract_range "function Scale"            "renames" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-scale.txt"
extract_range "function Magnitude"        "pragma Inline" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-magnitude.txt"
extract_range "function Square_Magnitude" "pragma Inline" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-square_magnitude.txt"
extract_range "function Normalize"        "pragma Inline" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-normalize.txt"

extract_range_exclusive "generic" "^package Math_2D" "${MATH_2D_SOURCE}/math_2d-triangles.ads"    "math_2d-triangles-generic.txt"
extract_range_exclusive "generic" "^package Math_2D" "${MATH_2D_SOURCE}/math_2d-points.ads"       "math_2d-points-generic.txt"
extract_range_exclusive "generic" "^package Math_2D" "${MATH_2D_SOURCE}/math_2d-trigonometry.ads" "math_2d-trigonometry-generic.txt"
extract_range_exclusive "generic" "^package Math_2D" "${MATH_2D_SOURCE}/math_2d-vectors.ads" "math_2d-vectors-generic.txt"
