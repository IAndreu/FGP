#include "graph.h"
#include <iostream>
#include <vector>
#include <zlib.h>
#include <stdio.h>
#include <string.h>
#include "paf.h"
#include <map>
#include "bubble_chain.h"
#include <queue>
#include <tuple>
#include <assert.h>
#include <sstream>
#include "minimizer_sketch.h"
#include "minimap.h"
#include "modmap.c"
#include "kthread.h"
using namespace std;
vector<vector<uint32_t>> best_buddy_separate(bool** seen, float** best_buddy, uint32_t **connect_num, uint32_t len);
vector<vector<uint32_t>> best_buddy_merge(bool** seen, float** best_buddy, uint32_t **connect_num, uint32_t len, uint32_t target, vector<uint32_t> inside_connections, bool check_identity);
vector<vector<uint32_t>> order_fixing(uint32_t **connect_num, vector<vector<uint32_t>> order_input, vector<uint32_t>* orientation_result, vector<uint32_t>* haplo_result);
vector<vector<uint32_t>> ordered_breaking(uint32_t** connect_num,vector<vector<uint32_t>> order_result, vector<uint32_t> orientation_result, vector<uint32_t> haplo_result);
vector<vector<uint32_t>> best_buddy_merge_final(bool** seen, float** best_buddy, uint32_t **connect_num, uint32_t len, uint32_t target, vector<uint32_t> inside_connections);

size_t stringCount(const std::string& referenceString,
                   const std::string& subString) {

  const size_t step = subString.size();

  size_t count(0);
  size_t pos(0) ;

  while( (pos=referenceString.find(subString, pos)) !=std::string::npos) {
    pos +=step;
    ++count ;
  }

  return count;
}
