
#pragma once
#include <concepts>
#include <cstdio>
#include <fstream>
#include <functional>
#include <iostream>
#include <map>
#include <mutex>
#include <optional>
#include <queue>
#include <span>
#include <sstream>
#include <stack>
#include <string>
#include <thread>
#include <type_traits>
#include <unordered_map>
#include <variant>
#include <vector>


#define GETTER inline auto
#define SETTER inline void

#ifdef max
#undef max
#endif

#ifdef min
#undef min
#endif

template <typename... T> using var           = std::variant<T...>;
using s                                      = std::string;
using sv                                     = std::string_view;

template <typename T> using v                = std::vector<T>;
template <typename T> using up               = std::unique_ptr<T>;
template <typename T> using sp               = std::shared_ptr<T>;
template <typename T> using opt              = std::optional<T>;
template <typename T> using optref           = std::optional<std::reference_wrapper<T>>;
template <typename T, typename U> using p    = std::pair<T, U>;
template <typename T, typename U> using umap = std::unordered_map<T, U>;
template <typename T, typename U> using map  = std::map<T, U>;
using Number                                 = double;
using Integer                                = int;
using ui                                     = uint32_t;
using si                                     = int32_t;
using sz                                     = size_t;
using sc                                     = signed char;
using uc                                     = unsigned char;

#define mu std::make_unique
#define mv std::move
#define mksh std::make_shared
#define g std::get


namespace Shree {


using atype = opt<var<s>>;
enum TokenType : int {
};

struct Token {
          TokenType mType;
          int mLine         = 0;
          var<std::monostate, s, int, double> mContent;
};

struct Scanner {
          Scanner(const sv inSource) : mSource(inSource) {}
          v<Token> Scan() {
                    while(not IsAtEnd())
                    {
                              mStart = mCurrent;
                              ScanToken();                    
                    }
                    mTokens.push_back(Token{.mType=TokenType::EOF_, .mLine = mLine});
                    return mTokens;
          }

          private:
          void ScanToken() {
                    char c = Advance();
                    switch(c)
                    {
                              
                    case '\n':
                              mLine++;
                              return;
                    case '\r':
                    case ' ':
                    case '\t':
                              return;
                              break;
                    
                    default:
                    
                    break;
                    
                    }
          }

          const sv mSource;
          v<Token> mTokens;
          int mStart   = 0;
          int mCurrent = mStart;
          int mLine    = 1;

          bool IsAtEnd() { return mCurrent >= mSource.length(); }
          char Advance() { return mSource[mCurrent++]; }
          char Peek() {
                    if (IsAtEnd()) return '\0';
                    return mSource[mCurrent];
          }
          bool Match(char inChar) {
                    if (IsAtEnd()) return false;
                    if (mSource[mCurrent] != inChar) return false;
                    mCurrent++;
                    return true;
          }
};
struct Visitor {
};
struct Expr__ {

                              virtual atype Accept(Visitor& inVisitor) = 0;
                              virtual ~Expr__()                          = default;
                        };

                    struct Parser {
                    
                                    Parser(v<Token>& inTokens) : mTokens(inTokens) {}
                    
                    private:
                    
                                    bool Check(TokenType inType) {
                                          if (IsAtEnd()) return false;
                                                      return Peek().mType == inType;
                                    }

                                    Token Advance() {
                                                if (not IsAtEnd()) {
                                                            mCurrent++;
                                                }
                                                return Previous();
                                    }
                                    Token Consume(TokenType inType, const sv inStr) {
                                          if (Check(inType)) return Advance();
                                          std::cout << inStr << "\n";
                                          return {};
                                    }
                                    bool IsAtEnd() { return Peek().mType == TokenType::EOF_; }
                                    Token Peek() { return mTokens[mCurrent]; }
                                    Token Previous() { return mTokens[mCurrent - 1]; }


                                    int mCurrent = 0;
                                    v<Token> mTokens;
                                    template <typename... T> bool MatchAndAdvance(T... inTokenType) {
                                                bool retval = false;
                                                (
                                                      [&]() {
                                                            if (Check(inTokenType)) {
                                                                        if (retval == false) {
                                                                                    Advance();
                                                                                    retval = true;
                                                                        }
                                                            }
                                                      }(),
                                                      ...);
                                                return retval;
                                    }
                  
                    };
                        
}