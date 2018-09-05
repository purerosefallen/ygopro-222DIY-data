--祝福的星晶兽 芙蕾雅
local m=47510010
local cm=_G["c"..m]
function c47510010.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510010.psplimit)
    c:RegisterEffect(e1)  
    --tohand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510010)
    e2:SetCondition(c47510010.pencon)
    e2:SetTarget(c47510010.thtg)
    e2:SetOperation(c47510010.thop)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,47510011)
    e3:SetCost(c47510010.drcost)
    e3:SetTarget(c47510010.drtg)
    e3:SetOperation(c47510010.drop)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e4)
    --sunmoneffect
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetCountLimit(1,47510000)
    e5:SetCost(c47510010.cost)
    e5:SetOperation(c47510010.atkop)
    c:RegisterEffect(e5)
    --return
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510010,0))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_QUICK_O)
    e6:SetRange(LOCATION_HAND)
    e6:SetCode(EVENT_FREE_CHAIN)
    e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e6:SetHintTiming(0,TIMING_END_PHASE)
    e6:SetCountLimit(1,47510011)
    e6:SetCost(c47510010.spcost)
    e6:SetTarget(c47510010.sptg)
    e6:SetOperation(c47510010.spop)
    c:RegisterEffect(e6)
end
function c47510010.pefilter(c)
    return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WIND)
end
function c47510010.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510010.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510010.cfilter(c)
    return c:IsSetCard(0x5de) or c:IsSetCard(0x5da) 
end
function c47510010.pencon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c47510001.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c47510010.filter(c)
    return c:IsSetCard(0x5da) and c:IsAbleToHand()
end
function c47510010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c47510010.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510010.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c47510010.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47510010.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=g:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
    end
end
function c47510010.filter2(c)
    return c:IsLocation(LOCATION_HAND) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x5de) or c:IsSetCard(0x5da)
end
function c47510010.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510010.filter2,tp,LOCATION_HAND,0,1,nil) end
    local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    local g=Duel.GetMatchingGroup(c47510010.filter2,tp,LOCATION_HAND,0,nil)
    local ct=math.min(ft-1,g:GetCount())
    local sg=g:Select(tp,1,ct,nil)
    e:SetLabel(sg:GetCount())
    Duel.SendtoGrave(sg,REASON_COST)
end
function c47510010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(e:GetLabel())
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c47510010.drop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Draw(p,d,REASON_EFFECT)
end
function c47510010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c47510010.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1500)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        tc:RegisterEffect(e2)
        local e3=Effect.CreateEffect(e:GetHandler())
        e3:SetType(EFFECT_TYPE_SINGLE)
        e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE+EFFECT_INDESTRUCTABLE_EFFECT)
        e3:SetValue(1)
        e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e3)
        tc=g:GetNext()
    end
end
function c47510010.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return not c:IsPublic() and c:GetFlagEffect(47510010)==0 end
    c:RegisterFlagEffect(47510010,RESET_CHAIN,0,1)
end
function c47510010.spfilter(c)
    return c:IsSetCard(0x5da) or c:IsSetCard(0x5de) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(47510010)
end
function c47510010.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c47510010.spfilter(chkc) end
    local c=e:GetHandler()
    if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c47510010.spfilter,tp,LOCATION_ONFIELD,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
    local g=Duel.SelectTarget(tp,c47510010.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c47510010.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
        local tc=Duel.GetFirstTarget()
        if tc:IsRelateToEffect(e) then
            Duel.SendtoHand(tc,nil,REASON_EFFECT)
        end
    end
end