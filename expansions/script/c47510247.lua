--爱与战争之神 阿娜特
local m=47510247
local cm=_G["c"..m]
function c47510247.initial_effect(c)
    --revive limit
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --special summon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0)  
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510247.psplimit)
    c:RegisterEffect(e1)  
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510247,0))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e2:SetCondition(c47510247.spcon)
    e2:SetOperation(c47510247.spop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510247,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47510247)
    e3:SetTarget(c47510247.pptg)
    e3:SetOperation(c47510247.ppop)
    c:RegisterEffect(e3)
    --linkchange
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetCountLimit(1,47510000)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCost(c47510247.cost)
    e4:SetTarget(c47510247.target)
    e4:SetOperation(c47510247.operation)
    c:RegisterEffect(e4)
    --atk
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetTarget(c47510247.bffilter)
    e5:SetValue(2000)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(LOCATION_MZONE,0)
    e6:SetTarget(c47510247.bffilter)
    e6:SetValue(1)
    c:RegisterEffect(e6)
    --xyzchange
    local e7=Effect.CreateEffect(c)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetCountLimit(1,47510248)
    e7:SetRange(LOCATION_PZONE)
    e7:SetCost(c47510247.xcost)
    e7:SetTarget(c47510247.xtg)
    e7:SetOperation(c47510247.xop)
    c:RegisterEffect(e7)
end
function c47510247.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c47510247.bffilter(c,e)
    return c:IsRace(RACE_WARRIOR) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND) and c~=e:GetHandler()
end
function c47510247.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510247.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510247.rfilter(c,tp)
    return c:IsLevelAbove(6) and c:IsType(TYPE_PENDULUM) and (c:IsControler(tp) or c:IsFaceup())
end
function c47510247.mzfilter(c,tp)
    return c:IsControler(tp) and c:GetSequence()<5
end
function c47510247.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510247.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47510247.mzfilter,ct,nil,tp))
end
function c47510247.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510247.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=nil
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:Select(tp,2,2,nil)
    elseif ft==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510247.mzfilter,1,1,nil,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g2=rg:Select(tp,1,1,g:GetFirst())
        g:Merge(g2)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510247.mzfilter,2,2,nil,tp)
    end
    Duel.Release(g,REASON_COST)
    c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(47510247,1))
end
function c47510247.filter(c,e,tp)
    return (c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_WARRIOR)) and c:IsFaceup() and c:IsAbleToHand() 
end
function c47510247.pptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
        and Duel.IsExistingMatchingCard(c47510247.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c47510247.ppop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft<=0 then return end
    if ft>2 then ft=2 end
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47510247.filter,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
    if g:GetCount()~=0 then 
        Duel.SendtoHand(g,nil,REASON_EFFECT)    
    end
end
function c47510247.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510247.lfilter(c)
    return c:IsFaceup()
end
function c47510247.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c47510247.lfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510247.lfilter,tp,LOCATION_SZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47510247.lfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c47510247.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e2=Effect.CreateEffect(tc)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetRange(LOCATION_SZONE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
        e2:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_LEFT+LINK_MARKER_TOP_RIGHT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2)
    end
end
function c47510247.xfilter(c)
    return c:IsSummonableCard()
end
function c47510247.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510247.xfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47510247.xfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    e:SetLabel(g:GetFirst():GetLevel())
    Duel.SendtoGrave(g,REASON_COST)
end
function c47510247.filter1(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER)
end
function c47510247.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingTarget(c47510247.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
function c47510247.xop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c47510247.filter1,tp,LOCATION_MZONE,0,tc)
    local lc=g:GetFirst()
    local lv=e:GetLabel()
    while lc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
        e1:SetValue(lv)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        lc:RegisterEffect(e1)
        lc=g:GetNext()
    end
end