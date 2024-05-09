const express = require('express');
const bodyParser = require('body-parser');
const app = express();
const cors = require('cors');
const { v4: uuidv4 } = require('uuid');
require("dotenv").config();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));


// const configuration = {
//   apiKey: OPENAI_API_KEY,
// };
// const openai = new OpenAIApi(configuration);



let diaries = [
    { diaryId: 1, date: '2024-05-28', emotion: '화나요', weather: '비', content: '오늘은 정말 기쁜 하루였다. 왜냐하면 기뻤기 때문이다 ㅎㅎ 야호야호 테스트 중입니당~!\n 안녕하세요~!'},
    { diaryId: 2, date: '2024-05-07', emotion: '슬퍼요', weather: '맑음', content: '오늘은 정말 기쁜 하루'},
    { diaryId: 3, date: '2024-05-07', emotion: '행복해요', weather: '맑음', content: '오늘은 정말 안 좋은 하루' },
    { diaryId: 4, date: '2024-05-07', emotion: '행복해요', weather: '흐림', content: '오늘은 정말 좋은 하루' } // dummy data
];

let calendars = [
    {calendarId: 1, date: '2024-05-06', startTime: '00:00', endTime: '16:00', text: '테스트1'},
    {calendarId: 2, date: '2024-05-09', startTime: '00:00', endTime: '16:00', text: '테스트2'},
    {calendarId: 3, date: '2024-05-09', startTime: '05:00', endTime: '16:40', text: '테스트2'},
    {calendarId: 4, date: '2024-05-09', startTime: '01:00', endTime: '23:59', text: '테스트2'},
    {calendarId: 5, date: '2024-05-09', startTime: '07:30', endTime: '21:00', text: '테스트2'},
    {calendarId: 6, date: '2024-05-07', startTime: '00:30', endTime: '18:00', text: '테스트3'},
    {calendarId: 7, date: '2024-05-07', startTime: '00:00', endTime: '16:00', text: '테스트3'},
]

app.get('/', (req, res) => {
    res.send('Hello, server!');
});

// 일기 조회
app.get('/diary', (req, res) => {
    res.send(diaries);
    console.log('일기 조회 get API 연결 성공', diaries);
});

// 사이드바 조회
app.get('/sidebar', (req, res) => {
    const emotionCounts = {};
    diaries.forEach(diary => {
        const emotion = diary.emotion;
        console.log("Emotion: ", emotion);
        if (emotionCounts[emotion]) {
            emotionCounts[emotion]++;
        } else {
            emotionCounts[emotion] = 1;
        }
        });
    
        // JSON.stringify()를 사용하여 객체를 JSON 문자열로 변환하여 보냄
    res.send(JSON.stringify(emotionCounts));
    console.log(emotionCounts);
});

// 일기 작성
app.post('/diary_write', (req, res) => {
    const diaryId = uuidv4();
    const date = req.body.date;
    const emotion = req.body.emotion;
    const weather = req.body.weather;
    const content = req.body.content;
    
    const parsedDate = date.slice(0, 10);

    const newData = {
        diaryId: diaryId,
        date: parsedDate,
        emotion: emotion,
        weather: weather,
        content: content
    };
    diaries.push(newData);
    res.json(diaries);
    console.log('일기 작성 post API 연결 성공', req.body);
});

// 일기 수정
app.put('/diary/:diaryId', (req, res) => {
    const diaryId = req.params.diaryId; // 수정할 일기의 ID
    const { date, emotion, weather, content } = req.body; // 수정할 내용
    const parsedDate = date.slice(0, 10);

    // 일기를 찾아서 수정
    const index= diaries.findIndex(diary => diary.diaryId === diaryId);
    if (index !== -1) {
        // 수정된 내용으로 일기 업데이트
        diaries[index] = {
            diaryId: diaryId,
            date: parsedDate,
            emotion: emotion,
            weather: weather,
            content: content
        };
        console.log('일기 수정 put API 연결 성공', req.body);
        res.send({ message: '일기가 수정되었습니다.', data: diaries[index] });
    } else {
        res.status(404).json({ message: '일기를 찾을 수 없습니다.' });
    }
});

// 일기 삭제
app.delete('/diary/:diaryId', (req, res) => {
    const diaryId = req.params.diaryId; // 삭제할 일기의 ID

    const index = diaries.findIndex(diary => diary.diaryId === diaryId);
    if (index !== -1) {
        diaries.splice(index, 1); // 배열에서 해당 일기를 삭제
        console.log('일기 삭제 delete API 연결 성공', diaries);
        res.json({ message: '일기가 삭제되었습니다.' });
    } else {
        res.status(404).json({ message: '해당 ID를 가진 일기를 찾을 수 없습니다.' });
    }
});


//캘린더 일정 조회
app.get('/calendar/:date', (req, res) => {
    const requestedDate = req.params.date;
    const filteredCalendars = calendars.filter(calendar => calendar.date === requestedDate);
    res.json(filteredCalendars);
    console.log('일정 조회 get API 연결 성공', req.body);
});

// 캘린더 일정 작성
app.post('/calendar', (req, res) => {
    const calendarId = uuidv4();
    const {date, startTime, endTime, text} = req.body;
    const newData = {
        calendarId: calendarId,
        date: date, 
        startTime: startTime, 
        endTime: endTime, 
        text: text
    }
    console.log(calendarId);
    calendars.push(newData);
    res.json(calendars);
    console.log('일정 작성 post API 연결 성공', req.body);

})

// 일정 수정
app.put('/calendar/:calendarId', (req, res) => {
    const calendarId = req.params.calendarId;
    const {date, startTime, endTime, text} = req.body;
    
    const index = calendars.findIndex(calendar => calendar.calendarId === calendarId);
    if (index !== -1) {
        calendars[index] = {
            calendarId: calendarId,
            date: date,
            startTime: startTime,
            endTime: endTime, 
            text: text
        }
        console.log('일정 수정 put API 연결 성공', req.body);
        res.send({ message: '일정이 수정되었습니다.', data: calendars[index] });
    } else {
        res.status(404).json({ message: '일정을 찾을 수 없습니다.' });
    }
})

//일정 삭제
app.delete('/calendar/:calendarId', (req, res) => {
    const calendarId = req.params.calendarId;

    const index = calendars.findIndex(calendar => calendar.calendarId === calendarId);
    if (index !== -1) {
        console.log('일정 삭제 delete API 연결 성공', diaries);
        res.json({ date: calendars[index].date});
        calendars.splice(index, 1); // 배열에서 해당 일기를 삭제
    } else {
        res.status(404).json({ message: '해당 ID를 가진 일정을 찾을 수 없습니다.' });
    }
});

app.listen(8080, function () {
 console.log('listening on 8080')
}); 
