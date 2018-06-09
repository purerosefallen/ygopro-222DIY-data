--传灵 鸟羽
function c22600105.initial_effect(c)
     --spirit return
    aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    
    --to deck
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,22600105)
    e2:SetCost(c22600105.dtcost)
    e2:SetCondition(c22600105.dtcon)
    e2:SetTarget(c22600105.dttg)
    e2:SetOperation(c22600105.dtop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,0x1c0)
    e3:SetCondition(c22600105.con)
    c:RegisterEffect(e3)

    --draw
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,22600135)
    e4:SetCondition(c22600105.dcon)
    e4:SetTarget(c22600105.dtg)
    e4:SetOperation(c22600105.dop)
    c:RegisterEffect(e4)
end

function c22600105.dtcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c22600105.dtfilter(c)
    return c:IsAbleToDeck()
end
function c22600105.dttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
    local g2=Duel.GetMatchingGroup(c22600105.dtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
    if chk==0 then return g1:GetCount()>0 and g2:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g2,1,0,0)
end

function c22600105.dtop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600105.dtfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
    local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
    if ct>0 and g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoDeck(sg,sg:GetFirst():GetControler(),2,REASON_EFFECT)
    end
end
function c22600105.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_SPIRIT)
end
function c22600105.dtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22600105.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22600105.con(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c22600105.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c22600105.dcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
    and re:GetHandler()==e:GetHandler())
end

function c22600105.filter(c)
    return c:IsType(TYPE_SPIRIT)
end

function c22600105.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600105.filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(1)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c22600105.dop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c22600105.filter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
        local tg=Duel.SelectMatchingCard(tp,c22600105.filter,tp,LOCATION_HAND,0,1,1,nil)
        Duel.ConfirmCards(1-tp,tg)
        Duel.ShuffleHand(tp)
        local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
        Duel.Draw(p,d,REASON_EFFECT)
    end
end