const {
  Client,
  GatewayIntentBits,
  REST,
  Routes,
  EmbedBuilder,
} = require("discord.js");
const {
  createAudioPlayer,
  createAudioResource,
  joinVoiceChannel,
} = require("@discordjs/voice");
const fs = require("fs");
const path = require("path");
const axios = require("axios");
const words = require("profane-words");
require("dotenv").config();
const { GROQ_API_KEY } = process.env;

const { token, clientId, guildId } = require("./config.json");

const client = new Client({
  intents: [
    GatewayIntentBits.Guilds,
    GatewayIntentBits.GuildMessages,
    GatewayIntentBits.MessageContent,
    GatewayIntentBits.GuildVoiceStates,
    GatewayIntentBits.GuildMembers,
  ],
});

const audioPlayer = createAudioPlayer();
const conversationHistoryPath = path.join(
  __dirname,
  "conversationHistory.json"
);
let conversationHistory = {};

if (fs.existsSync(conversationHistoryPath)) {
  try {
    const data = fs.readFileSync(conversationHistoryPath, "utf-8");
    conversationHistory = JSON.parse(data);
  } catch (error) {
    console.error("Error loading conversation history:", error);
  }
} else {
  fs.writeFileSync(conversationHistoryPath, JSON.stringify({}));
}

const commands = [
  {
    name: "musicgame",
    description: "Play a music guessing game!",
    options: [
      { type: 1, name: "start", description: "Start the music guessing game" },
    ],
  },
  {
    name: "mute",
    description: "Mute a user",
    options: [
      { type: 6, name: "user", description: "User to mute", required: true },
      {
        type: 3,
        name: "time",
        description: "Duration to mute (e.g., 1s, 1h, 1d)",
        required: true,
      },
    ],
  },
  {
    name: "unmute",
    description: "Unmute a user",
    options: [
      { type: 6, name: "user", description: "User to unmute", required: true },
    ],
  },
  { name: "info", description: "Get information about the bot" },
  { name: "why", description: "Why was the bot created?" },
  { name: "who", description: "Who created the bot?" },
  {
    name: "jokes",
    description: "Get a random joke",
    options: [
      {
        type: 3,
        name: "type",
        description: "Type of joke",
        required: true,
        choices: [
          { name: "Any", value: "Any" },
          { name: "Programming", value: "Programming" },
          { name: "Pun", value: "Pun" },
          { name: "Miscellaneous", value: "Miscellaneous" },
          { name: "Christmas", value: "Christmas" },
          { name: "Dark", value: "Dark" },
          { name: "Spooky", value: "Spooky" },
          { name: "Official Joke", value: "Official" },
          { name: "Dad Joke", value: "Dad" },
          { name: "Chuck Norris", value: "Chuck" },
          { name: "Yo Momma", value: "YoMomma" },
          { name: "Taco Cat", value: "TacoCat" },
        ],
      },
    ],
  },
  {
    name: "ai",
    description: "Toggle AI chat mode",
    options: [
      { type: 1, name: "on", description: "Enable AI chat mode" },
      { type: 1, name: "off", description: "Disable AI chat mode" },
    ],
  },
  {
    name: "clear",
    description: "Clear conversation history for a user",
    options: [
      {
        type: 6,
        name: "user",
        description: "User to clear history",
        required: true,
      },
    ],
  },
];

const rest = new REST({ version: "10" }).setToken(token);

(async () => {
  try {
    console.log("Started refreshing application (/) commands.");
    await rest.put(Routes.applicationGuildCommands(clientId, guildId), {
      body: commands,
    });
    console.log("Successfully reloaded application (/) commands.");
  } catch (error) {
    console.error(error);
  }
})();

client.on("interactionCreate", async (interaction) => {
  if (!interaction.isCommand()) return;

  const { commandName, options } = interaction;

  if (commandName === "musicgame" && options.getSubcommand() === "start") {
    const musicFolder = "./music";
    const files = fs
      .readdirSync(musicFolder)
      .filter((file) => file.endsWith(".mp3"));

    if (files.length < 4) {
      return interaction.reply(
        "Not enough songs to play the game. Please add more mp3 files to the music folder."
      );
    }

    const selectedSongs = shuffleArray(files).slice(0, 4);
    const correctSong =
      selectedSongs[Math.floor(Math.random() * selectedSongs.length)];
    const voiceChannel = interaction.member.voice.channel;

    if (!voiceChannel) {
      return interaction.reply("You need to join a voice channel first!");
    }

    const connection = joinVoiceChannel({
      channelId: voiceChannel.id,
      guildId: interaction.guild.id,
      adapterCreator: interaction.guild.voiceAdapterCreator,
    });

    const resource = createAudioResource(path.join(musicFolder, correctSong));
    audioPlayer.play(resource);
    connection.subscribe(audioPlayer);

    const embed = new EmbedBuilder()
      .setColor("#0099ff")
      .setTitle("Guess the Song!")
      .setDescription("A song is playing! Can you guess which one it is?")
      .addFields(
        {
          name: "1️⃣",
          value: selectedSongs[0].replace(".mp3", ""),
          inline: true,
        },
        {
          name: "2️⃣",
          value: selectedSongs[1].replace(".mp3", ""),
          inline: true,
        },
        {
          name: "3️⃣",
          value: selectedSongs[2].replace(".mp3", ""),
          inline: true,
        },
        {
          name: "4️⃣",
          value: selectedSongs[3].replace(".mp3", ""),
          inline: true,
        }
      )
      .setFooter({ text: "Type the corresponding number to guess!" });

    await interaction.reply({ embeds: [embed] });

    const filter = (msg) => msg.author.id === interaction.user.id;
    const collector = interaction.channel.createMessageCollector({ filter });

    collector.on("collect", (msg) => {
      const guess = parseInt(msg.content);

      if (guess >= 1 && guess <= 4) {
        const selectedSong = selectedSongs[guess - 1].replace(".mp3", "");
        if (selectedSong === correctSong.replace(".mp3", "")) {
          msg.reply(
            `Correct! The song was **${correctSong.replace(".mp3", "")}**!`
          );
        } else {
          msg.reply(
            `Wrong! The correct song was **${correctSong.replace(
              ".mp3",
              ""
            )}**.`
          );
        }

        collector.stop();
        audioPlayer.stop(); // Stop the music
      }
    });
  } else if (commandName === "mute") {
    const user = options.getUser("user");
    const time = options.getString("time");

    const member = interaction.guild.members.cache.get(user.id);
    const muteRole = interaction.guild.roles.cache.find(
      (role) => role.name === "Muted"
    );

    if (!muteRole) {
      return interaction.reply('No "Muted" role found! Please create one.');
    }

    const ownerRole = interaction.guild.roles.cache.find(
      (role) => role.name === "Owner"
    );
    if (!interaction.member.roles.cache.has(ownerRole.id)) {
      return interaction.reply(
        "You don't have permission to use this command."
      );
    }

    await member.roles.add(muteRole);
    const voiceState = member.voice;
    if (voiceState.channel) {
      voiceState.setMute(true);
    }

    interaction.reply(`${user.tag} has been muted for ${time}.`);

    setTimeout(async () => {
      await member.roles.remove(muteRole);
      if (voiceState.channel) {
        voiceState.setMute(false);
      }
      interaction.followUp(`${user.tag} has been unmuted.`);
    }, parseTime(time));
  } else if (commandName === "unmute") {
    const user = options.getUser("user");
    const member = interaction.guild.members.cache.get(user.id);
    const muteRole = interaction.guild.roles.cache.find(
      (role) => role.name === "Muted"
    );

    if (!muteRole) {
      return interaction.reply('No "Muted" role found! Please create one.');
    }

    await member.roles.remove(muteRole);
    const voiceState = member.voice;
    if (voiceState.channel) {
      voiceState.setMute(false);
    }

    interaction.reply(`${user.tag} has been unmuted.`);
  } else if (commandName === "info") {
    await interaction.reply("I am created by jdagreat");
  } else if (commandName === "why") {
    await interaction.reply("Because I don't like dyno");
  } else if (commandName === "who") {
    await interaction.reply("The bot was created by jdagreat");
  } else if (commandName === "jokes") {
    const jokeType = options.getString("type");
    let joke;

    try {
      const response = await axios.get(
        `https://v2.jokeapi.dev/joke/${jokeType}?blacklistFlags=nsfw,racist,sexist,explicit`
      );
      joke = response.data;
      const { setup, delivery, joke: jokeText } = joke;

      if (setup && delivery) {
        await interaction.reply(`${setup}\n${delivery}`);
      } else {
        await interaction.reply(jokeText);
      }
    } catch (error) {
      console.error(error);
      await interaction.reply("Failed to fetch a joke. Try again later.");
    }
  } else if (commandName === "ai") {
    const subcommand = options.getSubcommand();
    if (subcommand === "on") {
      client.chatMode = true;
      await interaction.reply("AI is now ON.");
    } else {
      client.chatMode = false;
      await interaction.reply("AI is now OFF.");
    }
  } else if (commandName === "clear") {
    const user = options.getUser("user");
    if (conversationHistory[user.id]) {
      delete conversationHistory[user.id];
      fs.writeFileSync(
        conversationHistoryPath,
        JSON.stringify(conversationHistory)
      );
      await interaction.reply(
        `${user.tag}'s conversation history has been cleared.`
      );
    } else {
      await interaction.reply(`${user.tag} has no conversation history.`);
    }
  }
});

client.on("messageCreate", async (message) => {
  if (message.author.bot) return;

  const userId = message.author.id;
  const userMessage = message.content;

  if (!conversationHistory[userId]) {
    conversationHistory[userId] = [];
  }

  conversationHistory[userId].push(userMessage);
  if (conversationHistory[userId].length > 10) {
    conversationHistory[userId].shift();
  }

  fs.writeFileSync(
    conversationHistoryPath,
    JSON.stringify(conversationHistory)
  );

  const messageContent = message.content.toLowerCase();
  const containsProfanity = words.some((word) => messageContent.includes(word));

  if (containsProfanity) {
    message.delete();
    return;
  }

  if (client.chatMode) {
    try {
      const context = conversationHistory[userId].join("\n");
      const response = await getGroqChatCompletion(context);
      const reply = response.choices[0]?.message?.content.trim();
      if (reply) {
        await message.channel.send(reply);
      }
    } catch (error) {
      console.error("Error with GROQ API:", error);
    }
  }
});

client.login(token);

function shuffleArray(array) {
  for (let i = array.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [array[i], array[j]] = [array[j], array[i]];
  }
  return array;
}

function parseTime(time) {
  const timeUnits = { s: 1000, m: 60000, h: 3600000, d: 86400000 };
  const unit = time[time.length - 1];
  const value = parseInt(time.slice(0, -1));
  return value * (timeUnits[unit] || 0);
}

// GROQ SDK functions
const Groq = require("groq-sdk");
const groq = new Groq({ apiKey: GROQ_API_KEY });

async function getGroqChatCompletion(context) {
  return groq.chat.completions.create({
    messages: [
      {
        role: "user",
        content: context,
      },
    ],
    model: "llama3-8b-8192",
  });
}
