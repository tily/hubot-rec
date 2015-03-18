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
user1>> hubot hello
hubot>> hello!
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
  stoppedAt: <timestamp>
  messages: <list of msgs>
}
```
