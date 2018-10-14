--魅惑的星晶兽 萨提洛斯
local m=47510129
local cm=_G["c"..m]
function c47510129.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),2,2,c47510129.lcheck)
    c:EnableReviveLimit()  
    --to extra
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510129,0))
    e1:SetCategory(CATEGORY_TOEXTRA)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c47510129.thcon)
    e1:SetTarget(c47510129.thtg)
    e1:SetOperation(c47510129.thop)
    c:RegisterEffect(e1)    
    --pendulum set ＆ des
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510129,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47510129.pscon)
    e2:SetTarget(c47510129.pstg)
    e2:SetOperation(c47510129.psop)
    c:RegisterEffect(e2)
    --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47510129,2))
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,47510129)
    e3:SetCondition(c47510129.tecon)
    e3:SetTarget(c47510129.tetg)
    e3:SetOperation(c47510129.teop)
    c:RegisterEffect(e3)
end
function c47510129.lcheck(g)
    return g:IsExists(Card.IsLinkType,1,nil,TYPE_PENDULUM)
end
function c47510129.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47510129.thfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c47510129.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510129.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47510129.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c47510129.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47510129.pscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47510129.psfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47510129.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c47510129.psfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c47510129.psop(e,tp,eg,ep,ev,re,r,rp)
    if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and c47510129.psfilter(chkc) end
        if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
    if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47510129.psfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    local atk=tc:GetLeftScale()
    if g:GetCount()>0 and Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
       local dg=Duel.GetMatchingGroup(nil,tp,LOCATION_PZONE,0,nil)
       Duel.BreakEffect()
       Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
       local sg=dg:Select(tp,1,1,nil)
       Duel.HintSelection(sg)
       Duel.Destroy(sg,REASON_EFFECT)
    end
end
function c47510129.tecfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
end
function c47510129.tecon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47510129.tecfilter,1,nil,tp)
end
function c47510129.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47510129.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510129.tefilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c47510129.teop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47510129,3))
    local g=Duel.SelectMatchingCard(tp,c47510129.tefilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_EFFECT)
    end
end