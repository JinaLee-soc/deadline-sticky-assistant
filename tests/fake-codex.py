#!/usr/bin/python3
"""Synthetic JSON-RPC server; never authenticates or makes network requests."""
import json, sys, time
mode = open(__file__ + '.mode').read().strip()
def send(x):
    raw = json.dumps(x) + '\n'
    sys.stdout.write(raw[:5]);sys.stdout.flush();sys.stdout.write(raw[5:]);sys.stdout.flush()
for line in sys.stdin:
    m=json.loads(line);method=m['method'];i=m.get('id')
    if mode=='timeout': time.sleep(10);continue
    if method=='initialize': send({'id':i,'result':{}})
    elif method=='account/read': send({'id':i,'result':{'account':{'type':'apiKey' if mode=='apikey' else 'chatgpt'}}})
    elif method=='config/read': send({'id':i,'result':{'config':{'mcp_servers':{'test':{'command':'never-run'}}}}})
    elif method=='thread/start':
        assert m['params']['config']['mcp_servers.test.enabled'] is False
        assert m['params']['sandbox']=='read-only'
        assert m['params']['ephemeral'] is True
        send({'id':i,'result':{'thread':{'id':'synthetic'},'instructionSources':[]}})
    elif method=='mcpServerStatus/list': send({'id':i,'result':{'data':([{'name':'unexpected','tools':{'write':{}}}] if mode=='mcp' else []),'nextCursor':None}})
    elif method=='turn/start':
        if mode=='approval': send({'id':88,'method':'item/commandExecution/requestApproval','params':{}})
        elif mode=='tool': send({'method':'item/started','params':{'item':{'type':'commandExecution'}}})
        elif mode=='failed': send({'method':'turn/completed','params':{'turn':{'status':'failed'}}})
        else:
            send({'method':'item/completed','params':{'item':{'type':'agentMessage','phase':'final_answer','text':'Start with the interview outline.'}}})
            send({'method':'turn/completed','params':{'turn':{'status':'completed'}}})
