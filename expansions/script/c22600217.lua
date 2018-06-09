--占星少女  派瑟丝
function c22600217.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x262),2)
    c:EnableReviveLimit()
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c22600217.condition)
    e1:SetTarget(c22600217.target)
    e1:SetOperation(c22600217.operation)
    c:RegisterEffect(e1)
    --atkup
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e2:SetCondition(c22600217.atkcon)
    e2:SetTarget(c22600217.atktg)
    e2:SetOperation(c22600217.atkop)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22600217.tdcon)
    e3:SetTarget(c22600217.tdtg)
    e3:SetOperation(c22600217.tdop)
    c:RegisterEffect(e3)
end
function c22600217.condition(e,tp,eg,ep,ev,re,r,rp,chk)
    return ep~=tp and (re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP))
end
function c22600217.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x262) and c:IsAbleToDeck()
end
function c22600217.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c22600217.filter(chkc) end
    if chk==0 then return Duel.IsExistingMatchingCard(c22600217.filter,tp,LOCATION_ONFIELD,0,1,nil) end
    local tc=Duel.SelectTarget(tp,c22600217.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function c22600217.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
    end
    local ec=re:GetHandler()
    if Duel.NegateActivation(ev) and ec:IsRelateToEffect(re) then
        ec:CancelToGrave()
        Duel.SendtoDeck(ec,nil,2,REASON_EFFECT)
    end
end
function c22600217.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c22600217.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c22600217.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local x=g:GetSum(Card.GetLink)
    if chk==0 then return e:GetHandler():GetFlagEffect(22600217)==0 and Duel.IsPlayerCanDiscardDeck(tp,x) end
    e:GetHandler():RegisterFlagEffect(22600217,RESET_CHAIN,0,1)
end
function c22600217.cfilter1(c)
    return c:IsType(TYPE_LINK)
end
function c22600217.cfilter2(c)
    return c:IsSetCard(0x262)
end
function c22600217.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600217.cfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    local x=g:GetSum(Card.GetLink)
    Duel.ConfirmDecktop(tp,x)
    Duel.BreakEffect()
    local sx=Duel.GetDecktopGroup(tp,x)
    if sx:GetCount()>0 then
        Duel.DisableShuffleCheck()
        if sx:IsExists(c22600217.cfilter2,1,nil) then
            local ct=sx:FilterCount(c22600217.cfilter2,nil)
            local c=e:GetHandler()
            if c:IsRelateToEffect(e) and c:IsFaceup() then
                local e1=Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_UPDATE_ATTACK)
                e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
                e1:SetValue(ct*300)
                c:RegisterEffect(e1)
            end
        end
    end
    Duel.BreakEffect()
    Duel.ShuffleDeck(tp)
end
function c22600217.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c22600217.tdfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end

function c22600217.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600217.tdfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c22600217.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c22600217.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c22600217.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
    end
end