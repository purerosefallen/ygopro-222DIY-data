--一般店员 姬塔
function c47500017.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsCode,47500000),2,2)
    --to extra
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500017,0))
    e1:SetCategory(CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,47500017)
    e1:SetCondition(c47500017.tecon)
    e1:SetTarget(c47500017.tetg)
    e1:SetOperation(c47500017.teop)
    c:RegisterEffect(e1)  
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500017,2))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47500016)
    e2:SetCondition(c47500017.drcon)
    e2:SetTarget(c47500017.drtg)
    e2:SetOperation(c47500017.drop)
    c:RegisterEffect(e2) 
end
c47500017.card_code_list={47500000}
function c47500017.drcfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_PZONE) and c:GetPreviousControler()==tp
end
function c47500017.drcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47500017.drcfilter,1,nil,tp)
end
function c47500017.thfilter(c)
    return c:IsFaceup() and c:IsCode(47500000) and c:IsAbleToHand()
end
function c47500017.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.IsExistingMatchingCard(c47500017.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c47500017.drop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47500017.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,tp,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47500017.lcheck(g,lc)
    return g:IsExists(Card.IsCode,1,nil,47500000)
end
function c47500017.tecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47500017.tefilter(c,code)
    return aux.IsCodeListed(c,47500000) and c:IsAbleToHand() and c:GetOriginalCode()~=code and c:IsType(TYPE_PENDULUM)
end
function c47510001.penfilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c47500017.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500017.tefilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c47510001.penfilter,tp,LOCATION_EXTRA,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47500017.teop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c47500017.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    local code=tc:GetOriginalCode()
    if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c47500017.tefilter,tp,LOCATION_DECK,0,1,1,code)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,tp,REASON_EFFECT)
        end
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47500017.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c47500017.splimit(e,c)
    return c:IsSetCard(0x5d0) or c:IsSetCard(0x5da) or c:IsSetCard(0x5de) or c:IsSetCard(0x5d3) or aux.IsCodeListed(c,47500000) or c:IsSetCard(0x813)
end