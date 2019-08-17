# message_manager.gd (autoload)
# Manages node messages (events) passing recieving

extends Node

# Dictionary of event listeners
# structure: { "message_name": [listener nodes] }
var listeners = {}

# Subscribe to message (adds node to listeners).
func listen(event: String, node: Node) -> void:
    if not listeners.has(event):
        listeners[event] = []
    listeners[event].append(node)


# Unsubscribe to message (removes node from listeners).
func ignore(event: String, node: Node) -> void:
    if listeners.has(event):
        listeners[event].erase(node)


# Send the message to all listeners, that have a method with the same name.
func emit(event: String, args) -> void:
    if not listeners.has(event):
        return

    for node in listeners[event]:
        if node.has_method(event):
            node.call(event, args)


# Send the message to a message group
func emitg(event: String, args) -> void:
    get_tree().call_group(str("mm_", event), event, args)
