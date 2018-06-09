--超越者 被赋生的米莉亚姆
local m=80000012
local cm=_G["c"..m]
cm.dfc_front_side=m
cm.dfc_back_side=80000006
cm.afkind=6--jingao
cm.is_named_with_yvwan=1
cm.can_exchange=1
function cm.initial_effect(c)
    Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
    --summon search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,2))
    e1:SetCategory(CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetCondition(cm.thcon)
    e1:SetTarget(cm.thtg)
    e1:SetOperation(cm.thop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
    c:RegisterEffect(e2)
    local e3=e1:Clone()
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e3)
     --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
    e4:SetCondition(cm.spcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
    --to deck
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,0))
    e5:SetCategory(CATEGORY_TODECK)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_HAND)
    e5:SetCondition(cm.condition)
    e5:SetTarget(cm.target)
    e5:SetOperation(cm.operation)
    c:RegisterEffect(e5)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetTurnID()~=Duel.GetTurnCount() and e:GetHandler():GetFlagEffect(cm.dfc_back_side)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,80000000+c.afkind,0,0x2021,afatk[c.afkind],afdev[c.afkind],aflv[c.afkind],RACE_CYBERSE,ATTRIBUTE_EARTH) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:ResetFlagEffect(m)
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
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    return (num%2)==0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,80000100,0,0x4011,c:GetTextAttack(),c:GetTextDefense(),c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute()) and c:IsAbleToDeck() end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,tp,LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
    Sym.operation(e,tp,eg,ep,ev,re,r,rp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    return (num%2)==0
end
function cm.thfil(c)
    return Sym.isyvwan(c) and c:IsAbleToHand() and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfil,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfil,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end