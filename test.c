#include <string.h>
#include "iostream"
using namespace std;

int main(){
  char label[] = "Long Long Long Long\r\r\nAA\r\r\n\r\r\n\003";
  char *bufpos;
  bufpos = label;
  int totalsize = strlen(label) -1;

          int spos;
            //cout << "totalsize is" << totalsize << endl;
        for(spos=(totalsize-1); spos > 0; spos -= 1){
            //cout << "spos is: " << spos << "char is" << bufpos[spos] << endl;
            if (bufpos[spos] != '\r' && bufpos[spos] != '\n'){
              break;
            }
            totalsize -= 1;
        }
        cout << "spos is: " << spos  << endl;
        strncpy(&(bufpos[spos+1]), "\r\r\n\003", 4);
        /* Terminate */
        bufpos[spos+5] = 0;

  cout << bufpos << endl;
  return 0;
}
