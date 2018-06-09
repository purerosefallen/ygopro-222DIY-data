Sym=Sym or {}
local cm=Sym
jiexi=1
gudai=2
shenmi=3
xuanlan=4
sibinie=5
jingao=6
afatk={1500,1800,1500,2100,1200,2700}
afdev={500,600,2100,1500,1200,2700}
aflv={1,1,3,5,1,7}
--initial effect
function cm.yuwancf1(c)
    --summon exchange
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(c:GetCode(),0))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.operation)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)    
end
function cm.canexchange(c)
    local code=c:GetCode()
    local mt=_G["c"..code]
    if not mt then
        _G["c"..code]={}
        if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
            mt=_G["c"..code]
            _G["c"..code]=nil
        else
            _G["c"..code]=nil
            return false
        end
    end
    return mt and mt.can_exchange 
end
function cm.isyvwan(c)
    local code=c:GetCode()
    local mt=_G["c"..code]
    if not mt then
        _G["c"..code]={}
        if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
            mt=_G["c"..code]
            _G["c"..code]=nil
        else
            _G["c"..code]=nil
            return false
        end
    end
    return (mt and mt.is_named_with_yvwan) or code==80000000
end
function cm.isartifact(c)
    local code=c:GetCode()
    local mt=_G["c"..code]
    if not mt then
        _G["c"..code]={}
        if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
            mt=_G["c"..code]
            _G["c"..code]=nil
        else
            _G["c"..code]=nil
            return false
        end
    end
    return mt and mt.is_named_with_artifact
end
function cm.afback(c)
    --back
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e0:SetCode(EVENT_ADJUST)
    e0:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e0:SetCountLimit(1)
    e0:SetCondition(cm.backon)
    e0:SetOperation(cm.backop)
    c:RegisterEffect(e0)    
end
function cm.backon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c.dfc_front_side and c:GetOriginalCode()==c.dfc_back_side
end
function cm.backop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tcode=c.dfc_front_side
    c:SetEntityCode(tcode)
    Duel.ConfirmCards(tp,Group.FromCards(c))
    Duel.ConfirmCards(1-tp,Group.FromCards(c))
    c:ReplaceEffect(tcode,0,0)
end
function cm.spreg(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
        c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,2)
    end
end
--function
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsPlayerCanSpecialSummonMonster(tp,80000100,0,0x4011,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute()) and Duel.IsPlayerCanSendtoDeck(tp,c) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SendtoDeck(c,tp,2,REASON_EFFECT)
    if not c:IsLocation(LOCATION_DECK) then return end
    Duel.ShuffleDeck(tp)
    c:ReverseInDeck()
    --spsummon effect init
    cm.sp(c)
    Duel.BreakEffect()
    --token summon
    cm.tk(tp,c)
end
function cm.uptodeck(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SendtoDeck(c,tp,2,REASON_EFFECT)
    if not c:IsLocation(LOCATION_DECK) then return end
    Duel.ShuffleDeck(tp)
    c:ReverseInDeck()
    --spsummon effect init
    cm.sp(c)
end
function cm.uptodeck2(c,y)
    Duel.SendtoDeck(c,tp,2,REASON_EFFECT)
    if not c:IsLocation(LOCATION_DECK) then return end
    if not y then Duel.ShuffleDeck(tp) end
    c:ReverseInDeck()
    --spsummon effect init
    cm.sp(c)
end
function cm.tk(tp,c)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    if Duel.IsPlayerCanSpecialSummonMonster(tp,80000000,0,0x4011,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute()) then
        local token=Duel.CreateToken(tp,80000000)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(c:GetTextAttack())
        e1:SetReset(RESET_EVENT+0xfe0000)
        token:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(c:GetTextDefense())
        token:RegisterEffect(e2)
        local e3=e1:Clone()
        e3:SetCode(EFFECT_CHANGE_LEVEL)
        e3:SetValue(c:GetOriginalLevel())
        token:RegisterEffect(e3)
        local e4=e1:Clone()
        e4:SetCode(EFFECT_CHANGE_RACE)
        e4:SetValue(c:GetOriginalRace())
        token:RegisterEffect(e4)
        local e5=e1:Clone()
        e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e5:SetValue(c:GetOriginalAttribute())
        token:RegisterEffect(e5)
        Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)    
    end
end
function cm.sp(c)
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(c:GetCode(),1))
    e0:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_DAMAGE)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e0:SetCode(EVENT_TO_HAND)
    e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
    e0:SetTarget(cm.sptg)
    e0:SetOperation(cm.spop)
    e0:SetReset(RESET_EVENT+0x1de0000)
    c:RegisterEffect(e0)
end
function cm.canspsumaf(c,tp)
    if not cm.isyvwan(c) or not c:IsType(TYPE_MONSTER) then return false end
    return Duel.IsPlayerCanSpecialSummonMonster(tp,80000000+c.afkind,0,0x2021,afatk[c.afkind],afdev[c.afkind],aflv[c.afkind],RACE_CYBERSE,ATTRIBUTE_EARTH) 
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return cm.canexchange(c) and c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,80000000+c.afkind,0,0x2021,afatk[c.afkind],afdev[c.afkind],aflv[c.afkind],RACE_CYBERSE,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,80000000+c.afkind,0,0x2021,afatk[c.afkind],afdev[c.afkind],aflv[c.afkind],RACE_CYBERSE,ATTRIBUTE_EARTH) then
        local tcode=c.dfc_back_side
        c:SetEntityCode(tcode,true)
        c:ReplaceEffect(tcode,0,0)
        Duel.BreakEffect()
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
