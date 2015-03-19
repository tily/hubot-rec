# hubot-rec

A hubot script to record chat histories

See [`src/rec.coffee`](src/rec.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-rec --save`

Then add **hubot-rec** to your `external-scripts.json`:

```json
["hubot-rec"]
```

## Sample Interaction

```
Hubot> Hubot rec start Some Chat History
Shell: started recording: Some Chat History at 2015/03/18 09:13:56 (room=Shell, duration=00:00:00, messages=0)
Hubot> Hubot rec status
Shell: now recording: Some Chat History at 2015/03/18 09:13:56 (room=Shell, duration=00:00:04, messages=1)
Hubot> Hubot rec cancel
Shell: cancelled recording: Some Chat History at 2015/03/18 09:13:56 (room=Shell, duration=00:00:09, messages=2)
Hubot> Hubot rec start Other Chat History
Shell: started recording: Other Chat History at 2015/03/18 09:14:13 (room=Shell, duration=00:00:00, messages=0)
Hubot> Hubot rec title Other Chat History for README
Shell: renamed Other Chat History to Other Chat History for README
Hubot> this is message
Hubot> this is message again
Hubot> this is another one
Hubot> Hubot rec stop
Shell: stopped recording: Other Chat History for README at 2015/03/18 09:14:13 (room=Shell, duration=00:01:09, messages=5)
Hubot> Hubot rec list
Shell: [0] Other Chat History for README at 2015/03/18 09:14:13 (room=Shell, duration=00:01:09, messages=5)
Hubot> Hubot rec delete 0
Hubot> Hubot rec list
Shell: (no recordings)
```

## Events

```
recStopped - {rec: <rec>, msg: <msg>}
```

Properties of `rec`:

```
{
  room: <room>,
  title: <title>,
  startedAt: <timestamp>,
  stoppedAt: <timestamp>,
  messages: <list of msgs>
}
```

## URLs

Recorded messages can be viewed at:

```
/rec
/rec/:id
```
