#include "tcpip/tcpip_testsuit.h"

#include <sys/types.h>
#include <sys/wait.h>
#include <cstdlib>
#include <iostream>
#include "util/common.h"
#include "tcpip/tcpip.h"

using std::cerr;
using std::cout;
using std::endl;

#define PORT_TRIAL 10

int tcpipTestRun(
  const function<int(const void *, int)>& server_func,
  const void* server_data,
  const function<int(const void *, int)>& client_func,
  const void* client_data)

  int connfd_server;
  char server_ip[] = "127.0.0.1";
  int port = rand() % 5000 + 1000;
  for(int i=0;i<PORT_TRIAL;i++) {
    if ((connfd_server = server_init(port)) == -1) {
      port = rand() % 5000 + 1000;
      cerr << "Cannot open the socket in port " << port;
      if(i==PORT_TRIAL-1) {
        cerr << "Connection failed." << endl;
      }
      return FAILURE;
    }
    else {
      break;
    }
  }

  pid_t childPID = fork();
  if (childPID >= 0) {  // fork was successful
    if (childPID == 0) {  // client
      int connfd_client;
      if ((connfd_client = client_init(server_ip.c_str(), port)) == -1) {
        cerr << "Cannot connect to " << server_ip << ":" << port << endl;
        cerr << "Connection failed." << endl;
        return FAILURE;
      }
      if (client_func(client_data) == FAILURE) {
        cerr << "client failed." << endl;
        return FAILURE;
      }
      if (client_close(connfd_client) == FAILURE) {
        cerr << "closing client failed." << endl;
        return FAILURE;
      }
    } else {  //server
      if (server_func(server_data) == FAILURE) {
        cerr << "server failed." << endl;
        return FAILURE;
      }
      if (server_close(connfd_server) == FAILURE) {
        cerr << "closing server failed." << endl;
        return FAILURE;
      }
      int client_returnStatus;    
      waitpid(childPID, &client_returnStatus, 0);
      if (client_returnStatus == FAILURE) {
        cerr << "client failed." << endl;
        return FAILURE;
      }
    }
  } else {  // fork failed
    cerr << "Fork failed." << endl;
    return FAILURE;
  }

  return SUCCESS;
}