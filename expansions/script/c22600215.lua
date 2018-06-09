--占星少女  凯普可乐丝
function c22600215.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x262),2)
    c:EnableReviveLimit()
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
    e1:SetCountLimit(1,22600215)
    e1:SetCondition(c22600215.condition)
    e1:SetTarget(c22600215.target)
    e1:SetOperation(c22600215.operation)
    c:RegisterEffect(e1)
    --cannot be target indestructable
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e2:SetTarget(c22600215.tgtg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22600215.tdcon)
    e3:SetTarget(c22600215.tdtg)
    e3:SetOperation(c22600215.tdop)
    c:RegisterEffect(e3)
end
function c22600215.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c22600215.filter1(c,link)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsLinkBelow(link)
end
function c22600215.tfilter(c)
    return c:IsFaceup()
end
function c22600215.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22600215.filter1(chkc) end
    if chk==0 then return Duel.IsExistingMatchingCard(c22600215.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc) and Duel.IsExistingMatchingCard(c22600215.tfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600215,0))
    Duel.SelectTarget(tp,c22600215.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc)
end
function c22600215.filter2(c)
    return not c:IsDisabled() and c:IsFaceup()
end
function c22600215.filter(c)
    return c:IsSetCard(0x262)
end
function c22600215.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local l=tc:GetLink()
    if not Duel.IsPlayerCanDiscardDeck(tp,l) then return end
    Duel.ConfirmDecktop(tp,l)
    Duel.BreakEffect()
    local g=Duel.GetDecktopGroup(tp,l)
    if g:GetCount()>0 then
        Duel.DisableShuffleCheck()
        if g:IsExists(c22600215.filter,1,nil) and Duel.IsExistingMatchingCard(c22600215.filter2,tp,0,LOCATION_MZONE,1,nil) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local sg=Duel.SelectMatchingCard(tp,c22600215.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
            Duel.NegateRelatedChain(sg:GetFirst(),RESET_TURN_SET)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCode(EFFECT_DISABLE)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            sg:GetFirst():RegisterEffect(e1)
            local e2=Effect.CreateEffect(c)
            e2:SetType(EFFECT_TYPE_SINGLE)
            e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e2:SetCode(EFFECT_DISABLE_EFFECT)
            e2:SetValue(RESET_TURN_SET)
            e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            sg:GetFirst():RegisterEffect(e2)
        end
        if g:FilterCount(c22600215.filter,nil)>=3 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 then
            Duel.SelectYesNo(tp,aux.Stringid(22600215,1))
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
            local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
            if dg:GetCount()>0 then
                Duel.BreakEffect()
                Duel.HintSelection(dg)
                Duel.Destroy(dg,REASON_EFFECT)
            end
        end
        Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
        Duel.BreakEffect()
        Duel.ShuffleDeck(tp)
    end
end
function c22600215.tgtg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(0x262)
end
function c22600215.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c22600215.tdfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end

function c22600215.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600215.tdfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c22600215.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c22600215.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c22600215.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
    end
end