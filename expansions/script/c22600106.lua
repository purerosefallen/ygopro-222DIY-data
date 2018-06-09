--传灵 花樱
function c22600106.initial_effect(c)
     --spirit return
    aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
    --cannot special summon
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(aux.FALSE)
    c:RegisterEffect(e1)
    
    --destroy hand
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_HANDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,22600106)
    e2:SetCost(c22600106.dhcost)
    e2:SetCondition(c22600106.dhcon)
    e2:SetTarget(c22600106.dhtg)
    e2:SetOperation(c22600106.dhop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetHintTiming(0,TIMING_TOHAND)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCondition(c22600106.con)
    c:RegisterEffect(e3)

    --tograve
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetProperty(EFFECT_FLAG_DELAY)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetCountLimit(1,22600136)
    e4:SetCondition(c22600106.scon)
    e4:SetTarget(c22600106.stg)
    e4:SetOperation(c22600106.sop)
    c:RegisterEffect(e4)
end

function c22600106.dhcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c22600106.dhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    local g1=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
    if chk==0 then return g1:GetCount()>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
    c22600106.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
    local ac=Duel.AnnounceCardFilter(tp,table.unpack(c22600106.announce_filter))
    Duel.SetTargetParam(ac)
    Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD_FILTER)
    Duel.SetOperationInfo(0,CATEGORY_HANDES,g1,1,0,0)
end

function c22600106.dhop(e,tp,eg,ep,ev,re,r,rp)
    local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
    local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD,nil)
    local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
    local tg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
    if tg:GetCount()>0 then
        Duel.ConfirmCards(tp,tg)
        if g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
            local sg=g:Select(tp,1,1,nil)
            Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
        end
        Duel.ShuffleHand(1-tp)
    end
end
function c22600106.cfilter(c)
    return c:IsFacedown() or not c:IsType(TYPE_SPIRIT)
end
function c22600106.dhcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(c22600106.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22600106.con(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c22600106.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c22600106.scon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not (e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
    and re:GetHandler()==e:GetHandler())
end

function c22600106.filter(c)
    return c:IsType(TYPE_SPIRIT) and c:IsAbleToGrave()
end
function c22600106.stg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c22600106.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c22600106.sop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c22600106.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end