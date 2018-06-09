--占星少女  libu
function c22600212.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x262),2,2)
    c:EnableReviveLimit()
    --draw
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCondition(c22600212.condition)
    e1:SetTarget(c22600212.target)
    e1:SetOperation(c22600212.operation)
    c:RegisterEffect(e1)
    
    --atk
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetHintTiming(0,0x1c0)
    e2:SetTarget(c22600212.atktg)
    e2:SetOperation(c22600212.atkop)
    c:RegisterEffect(e2)

    --todeck
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_TO_GRAVE)
    e3:SetCondition(c22600212.tdcon)
    e3:SetTarget(c22600212.tdtg)
    e3:SetOperation(c22600212.tdop)
    c:RegisterEffect(e3)
end

function c22600212.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c22600212.filter(c,tp)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and Duel.IsPlayerCanDraw(tp,c:GetLink()) and c:IsLinkBelow(Duel.GetFieldGroupCount(1-tp,0,LOCATION_DECK))
end

function c22600212.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22600212.filter(chkc) end
    if chk==0 then return Duel.GetMatchingGroupCount(c22600212.filter,tp,LOCATION_MZONE,0,nil,tp)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600212,0))
    Duel.SelectTarget(tp,c22600212.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
    local tc=Duel.GetFirstTarget()
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(tc:GetLink())
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,tc:GetLink())
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,tc:GetLink())
end

function c22600212.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    local l=tc:GetLink()
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    if Duel.Draw(p,d,REASON_EFFECT)==l then
        Duel.BreakEffect()
        local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,p,LOCATION_HAND,0,nil)
        if g:GetCount()==0 then return end
        Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
        local sg=g:Select(p,l,l,nil)
        Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
        Duel.SortDecktop(p,p,l)
        for i=1,l do
            local mg=Duel.GetDecktopGroup(p,1)
            Duel.MoveSequence(mg:GetFirst(),0)
        end
    end
end

function c22600212.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22600212,0))
    local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,2,2,nil)
    Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,g:GetCount(),0,0)
end

function c22600212.atkop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tc1=g:GetFirst()
    local tc2=g:GetNext()
    if tc1:IsFaceup() and tc1:IsRelateToEffect(e) and tc2:IsFaceup() and tc2:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue((tc1:GetAttack()+tc2:GetAttack())/2)
        tc1:RegisterEffect(e1)
        local e2=e1:Clone()
        tc2:RegisterEffect(e2)
    end
end

function c22600212.tdcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c22600212.tdfilter(c,e,tp)
    return c:IsSetCard(0x262) and c:IsAbleToDeck()
end

function c22600212.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22600212.tdfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(c22600212.tdfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c22600212.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end

function c22600212.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) then
        Duel.SendtoDeck(tc,tp,0,REASON_EFFECT)
    end
end