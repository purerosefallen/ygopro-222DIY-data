--占星少女  爱珂瑞
function c22600213.initial_effect(c)
     --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x262),2,2)
    c:EnableReviveLimit()
    --mill
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCountLimit(1,22600213)
    e1:SetCondition(c22600213.condition)
    e1:SetTarget(c22600213.target)
    e1:SetOperation(c22600213.operation)
    c:RegisterEffect(e1)

    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCost(c22600213.descost)
    e2:SetTarget(c22600213.destg)
    e2:SetOperation(c22600213.desop)
    c:RegisterEffect(e2)

    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22600213.tdcon)
    e3:SetTarget(c22600213.tdtg)
    e3:SetOperation(c22600213.tdop)
    c:RegisterEffect(e3)
end

function c22600213.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c22600213.filter1(c,link)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsLinkBelow(link)
end

function c22600213.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22600213.filter1(chkc) end
    if chk==0 then return Duel.IsExistingMatchingCard(c22600213.filter1,tp,LOCATION_MZONE,0,1,nil,tc) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600213,0))
    Duel.SelectTarget(tp,c22600213.filter1,tp,LOCATION_MZONE,0,1,1,nil,tc)
end

function c22600213.filter2(c)
    return c:IsAbleToHand() and c:IsSetCard(0x262)
end

function c22600213.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local l=tc:GetLink()
    if not Duel.IsPlayerCanDiscardDeck(tp,l) then return end
    Duel.ConfirmDecktop(tp,l)
    local g=Duel.GetDecktopGroup(tp,l)
    if g:GetCount()>0 then
        Duel.DisableShuffleCheck()
        if g:IsExists(c22600213.filter2,1,nil) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
            local sg=g:FilterSelect(tp,c22600213.filter2,1,1,nil)
            Duel.SendtoHand(sg,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,sg)
            Duel.ShuffleHand(tp)
            g:Sub(sg)
        end
        Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
        Duel.SortDecktop(tp,tp,g:GetCount())
        for i=1,g:GetCount() do
            local mg=Duel.GetDecktopGroup(tp,1)
            Duel.MoveSequence(mg:GetFirst(),0)
        end
    end
end

function c22600213.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x262) and c:IsAbleToGraveAsCost()
end

function c22600213.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600213.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c22600213.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
    Duel.SendtoGrave(g,REASON_COST) 
end

function c22600213.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c22600213.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end

function c22600213.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c22600213.tdfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end

function c22600213.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600213.tdfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c22600213.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c22600213.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c22600213.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
    end
end