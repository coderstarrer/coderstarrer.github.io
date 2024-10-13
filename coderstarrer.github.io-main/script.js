// Translations object
const translations = {
  en: {
    header: "Welcome to Sarvamitra Vayama Sangam",
    slide1: {
      title: "Welcome to Sarvamitra Vayama Sangam",
      desc: "Sarvamitra Vayama Sangam is a fitness center in Chirala, India dedicated to helping individuals achieve their health and wellness goals through comprehensive training programs and support.",
    },
    slide2: {
      title: "Why Join Sarvamitra Vayama Gym?",
      desc: [
        "State-of-the-art equipment",
        "Personalized training programs",
        "Group fitness classes",
        "Experienced trainers and nutrition guidance",
      ],
    },
    languageLabel: "Change language...",
  },
  te: {
    header: "సర్వమిత్ర వ్యాయామ సంఘానికి స్వాగతం",
    slide1: {
      title: "సర్వమిత్ర వ్యాయామ సంఘానికి స్వాగతం",
      desc: "సర్వమిత్ర వ్యాయామ సంఘం చీరాల, భారతదేశంలో ఉన్న ఒక ఆరోగ్య కేంద్రం, వ్యక్తులు తమ ఆరోగ్య మరియు ఆరోగ్య లక్ష్యాలను చేరుకునేందుకు సమగ్ర శిక్షణ ప్రణాళికలు మరియు మద్దతు అందించడంలో సహాయపడుతుంది.",
    },
    slide2: {
      title: "సర్వమిత్ర వ్యాయామ గYM కు చేరడానికి కారణాలు?",
      desc: [
        "మోడరన్ ఉపకరణాలు",
        "వ్యక్తిగత శిక్షణ ప్రణాళికలు",
        "సామూహిక వ్యాయామ తరగతులు",
        "అనుభవం ఉన్న శిక్షకులు మరియు పోషణ మార్గనిర్దేశం",
      ],
    },
    languageLabel: "భాష మార్చండి...",
  },
  hi: {
    header: "सर्वमित्र व्यायाम संघ में आपका स्वागत है",
    slide1: {
      title: "सर्वमित्र व्यायाम संघ में आपका स्वागत है",
      desc: "सर्वमित्र व्यायाम संघ चिराला, भारत में एक फिटनेस केंद्र है जो व्यक्तियों को उनकी स्वास्थ्य और कल्याण लक्ष्यों को प्राप्त करने में मदद करने के लिए समग्र प्रशिक्षण कार्यक्रम और समर्थन प्रदान करता है।",
    },
    slide2: {
      title: "सर्वमित्र व्यायाम जिम में क्यों शामिल हों?",
      desc: [
        "उन्नत उपकरण",
        "व्यक्तिगत प्रशिक्षण कार्यक्रम",
        "समूह फिटनेस कक्षाएं",
        "अनुभवी प्रशिक्षक और पोषण मार्गदर्शन",
      ],
    },
    languageLabel: "भाषा बदलें...",
  },
};

// Function to change language
function changeLanguage(language) {
  localStorage.setItem("selectedLanguage", language);
  updateContent(language);
}

// Function to update content in the HTML
function updateContent(language) {
  const headerTitle = document.getElementById("header-title");
  if (headerTitle) {
    headerTitle.innerText = translations[language].header;
  }

  const slide1Title = document.getElementById("slide1-title");
  if (slide1Title) {
    slide1Title.innerText = translations[language].slide1.title;
  }

  const slide1Desc = document.getElementById("slide1-desc");
  if (slide1Desc) {
    slide1Desc.innerText = translations[language].slide1.desc;
  }

  const slide2Title = document.getElementById("slide2-title");
  if (slide2Title) {
    slide2Title.innerText = translations[language].slide2.title;
  }

  const slide2Desc = document.getElementById("slide2-desc");
  if (slide2Desc) {
    slide2Desc.innerHTML = translations[language].slide2.desc
      .map((item) => `<li>${item}</li>`)
      .join("");
  }

  const languageLabel = document.getElementById("language-label");
  if (languageLabel) {
    languageLabel.innerText = translations[language].languageLabel;
  }
}

// Load selected language on page load
window.onload = function () {
  const savedLanguage = localStorage.getItem("selectedLanguage") || "en"; // Default to English if no language is saved
  changeLanguage(savedLanguage);
};

// Language Selector Event Listener (Only in settings.html)
const languageSelector = document.getElementById("language-selector");
if (languageSelector) {
  languageSelector.addEventListener("change", (event) => {
    const selectedLanguage = event.target.value;
    changeLanguage(selectedLanguage);
  });
}
