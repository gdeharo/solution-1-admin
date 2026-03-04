import dotenv from "dotenv";
import path from "node:path";
import express from "express";
import session from "express-session";
import intuitAuthRouter from "./routes/intuitAuth.js";
import invoiceImportRouter from "./routes/invoiceImport.js";
import estimatePoImportRouter from "./routes/estimatePoImport.js";

dotenv.config();

const app = express();
const port = Number(process.env.PORT ?? 3000);

app.use(express.json({ limit: "2mb" }));
app.use(
  session({
    secret: process.env.SESSION_SECRET || "change-me",
    resave: false,
    saveUninitialized: false,
    cookie: {
      httpOnly: true,
      sameSite: "lax"
    }
  })
);
app.use("/ui", express.static(path.join(process.cwd(), "public")));

app.get("/", (_req, res) => {
  res.redirect("/ui");
});

app.use(intuitAuthRouter);
app.use(invoiceImportRouter);
app.use(estimatePoImportRouter);

app.listen(port, () => {
  console.log(`qbo-dev listening on http://localhost:${port}`);
});
