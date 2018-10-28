--苍天的守护骑士 卡塔丽娜
local m=47550003
local cm=_G["c"..m]
function c47550003.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47550003.psplimit)
    c:RegisterEffect(e1) 
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCondition(c47550003.atkcon)
    e2:SetOperation(c47550003.atkop)
    c:RegisterEffect(e2)
    --tohand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCountLimit(1,47550003)
    e3:SetTarget(c47550003.thtg)
    e3:SetOperation(c47550003.thop)
    c:RegisterEffect(e3)    
    --spsummon
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_HAND)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCountLimit(1,47551003)
    e4:SetCondition(c47550003.con)
    e4:SetTarget(c47550003.target)
    e4:SetOperation(c47550003.operation)
    c:RegisterEffect(e4)
end
function c47550003.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c47550003.psplimit(e,c,tp,sumtp,sumpos)
    return not c47550003.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47550003.cfilter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c47550003.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47550003.cfilter,1,nil,tp)
end
function c47550003.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER))
end
function c47550003.atkop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c47550003.filter,tp,LOCATION_MZONE,0,nil)
    local tc=g:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(800)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
end
function c47550003.thfilter(c)
    return (c:IsSetCard(0x5d0) or c:IsSetCard(0x5da)) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PENDULUM) and not c:IsCode(47550003) and c:IsAbleToHand()
end
function c47550003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingMatchingCard(c47550003.thfilter,tp,LOCATION_DECK,0,1,nil) end
    local g=Duel.GetMatchingGroup(c47550003.thfilter,tp,LOCATION_DECK,0,nil)
    local ct=g:GetClassCount(Card.GetCode)
    if ct>2 then ct=2 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local dg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,ct,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,dg:GetCount(),tp,LOCATION_DECK)
end
function c47550003.thop(e,tp,eg,ep,ev,re,r,rp)
    local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    local ct=Duel.Destroy(dg,REASON_EFFECT)
    local g=Duel.GetMatchingGroup(c47550003.thfilter,tp,LOCATION_DECK,0,nil)
    if ct==0 or g:GetCount()==0 then return end
    if ct>g:GetClassCount(Card.GetCode) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=g:Select(tp,1,1,nil)
    if ct==2 then
        g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g2=g:Select(tp,1,1,nil)
        g1:Merge(g2)
    end
    Duel.SendtoHand(g1,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,g1)
end
function c47550003.cfilter(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and (c:IsRace(RACE_SPELLCASTER) or c:IsType(TYPE_PENDULUM) or c:IsAttribute(ATTRIBUTE_WATER))
        and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function c47550003.con(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47550003.cfilter,1,nil,tp)
end
function c47550003.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47550003.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end