--蔷薇的星晶兽 玫瑰女皇
local m=47510050
local cm=_G["c"..m]
function c47510050.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510050.psplimit)
    c:RegisterEffect(e1)  
    --recove
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510050)
    e2:SetTarget(c47510050.rectg)
    e2:SetOperation(c47510050.recop)
    c:RegisterEffect(e2)
    --spsum
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_LVCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510051)
    e3:SetCondition(c47510050.thcon)
    e3:SetTarget(c47510050.lvtg)
    e3:SetOperation(c47510050.lvop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --ntr
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_CONTROL)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetCountLimit(1,47510000)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCost(c47510050.cost)
    e5:SetTarget(c47510050.ntrtg)
    e5:SetOperation(c47510050.ntrop)
    c:RegisterEffect(e5)
    --effect
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_BE_MATERIAL)
    e6:SetCondition(c47510050.efcon)
    e6:SetOperation(c47510050.efop)
    c:RegisterEffect(e6)
    --synchro limit
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
    e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e7:SetValue(c47510050.synlimit)
    c:RegisterEffect(e7)
end
function c47510050.pefilter(c)
    return c:IsRace(RACE_PLANT) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c47510050.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510050.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510050.synlimit(e,c)
    if not c then return false end
    return not c:IsRace(RACE_DRAGON) or c:IsRace(RACE_PLANT) or c:IsSetCard(0x5da)
end
function c47510050.rcfilter(c)
    return c:IsFaceup() and c:GetAttack()>0
end
function c47510050.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47510050.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510050.rcfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c47510050.rcfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c47510050.recop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
        Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c47510050.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_PENDULUM) and c:IsPreviousLocation(LOCATION_HAND)
end
function c47510050.lvfilter(c)
    return c:IsRace(RACE_PLANT) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and c:IsType(TYPE_TUNER)
end
function c47510050.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510050.lvfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c47510050.lvop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47510050.lvfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) then
        local lv=tc:GetLevel()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL)
        e1:SetValue(lv)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
    end
end
function c47510050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510050.ntrfilter(c)
    return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c47510050.ntrtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c47510050.ntrfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510050.ntrfilter,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
    local g=Duel.SelectTarget(tp,c47510050.ntrfilter,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c47510050.ntrop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
        Duel.NegateRelatedChain(tc,RESET_TURN_SET)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_DISABLE_EFFECT)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e4:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e4:SetValue(LOCATION_DECKBOT)
        c:RegisterEffect(e4)
    end
end
function c47510050.efcon(e,tp,eg,ep,ev,re,r,rp)
    return r==REASON_SYNCHRO and e:GetHandler():GetReasonCard():IsRace(RACE_DRAGON)
end
function c47510050.efop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local rc=c:GetReasonCard()
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510050,1))
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetRange(LOCATION_MZONE)
    e1:SetLabel(ep)
    e1:SetValue(c47510050.tgval)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    rc:RegisterEffect(e1,true)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
    rc:RegisterEffect(e2,true)
end
function c47510050.tgval(e,re,rp)
    return rp==1-e:GetLabel()
end