import net from "net";

const server = net.createServer((socket) => {
    console.log("MT5 CONNECTED");

    let buffer = "";

    socket.on("data", (data) => {

        buffer += data.toString();

        const parts = buffer.split("\n");

        buffer = parts.pop() || "";

        for (const msg of parts) {

            if (!msg.trim()) continue;

            // LIGHTWEIGHT PRINT
            process.stdout.write(msg + "\n");
        }
    });

    socket.on("close", () => {
        console.log("MT5 DISCONNECTED");
    });

    socket.on("error", (err) => {
        console.log("SOCKET ERROR:", err.message);
    });
});

server.listen(5555, "127.0.0.1", () => {
    console.log("SERVER RUNNING");
});