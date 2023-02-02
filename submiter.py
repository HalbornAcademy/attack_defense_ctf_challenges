import requests

MASTER_IP = '100.127.117.59'

MY_IP = 'TODO'

TOKEN = 'TODO'


teams = requests.get(f'http://{MASTER_IP}/api/client/teams/').json()
tasks = requests.get(f'http://{MASTER_IP}/api/client/tasks/').json()

for team in teams:

    print('Team: ', team['name'])

    for task in tasks:
        if team['ip'] == MY_IP:
            continue
        url = f"http://{team['ip']}/{task['name']}/flags"
        response = requests.get(url)

        print('Task: ', task['name'])

        if 'No request made to the RPC' in response.text:
            print('First run the exploits')
            continue

        flags = response.json()
        print(flags)

        headers = {
        'X-Team-Token': TOKEN
        }

        result = requests.put(f'http://{MASTER_IP}/flags', json=flags, headers=headers)

        print(result.text)
