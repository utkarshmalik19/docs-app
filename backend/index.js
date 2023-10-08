const express = require('express');
const mongoose = require('mongoose');
const authRouter = require('./routes/auth');
const cors = require('cors');
const documentRouter = require('./routes/document');
const PORT = process.env.PORT | 3001;
const DB = "mongodb+srv://utkarshmalik19:utkarsh19@cluster0.j6omvrl.mongodb.net/?retryWrites=true&w=majority";
const app = express();

app.use(cors());
app.use(express.json());
app.use(authRouter);
app.use(documentRouter);

mongoose.connect(DB).then(()=>{
    console.log('Connection Successful');
}).catch((err)=>{
    console.log(err);
})

app.listen(PORT, "0.0.0.0", ()=>{
    console.log(`Connected at port ${PORT}`);
});