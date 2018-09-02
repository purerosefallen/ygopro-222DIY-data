--杰夫提
local m=47522011
local cm=_G["c"..m]
function c47522011.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,4,c47522011.lcheck)
    c:EnableReviveLimit() 
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47522011,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47522011)
    e1:SetCondition(c47522011.con)
    e1:SetTarget(c47522011.thtg)
    e1:SetOperation(c47522011.thop)
    c:RegisterEffect(e1)
    --Equip
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47522011,1))
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCategory(CATEGORY_EQUIP)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetHintTiming(0,TIMING_END_PHASE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,47522011)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTarget(c47522011.eqtg)
    e2:SetOperation(c47522011.eqop)
    c:RegisterEffect(e2)   
    --mudeki
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_SZONE,0)
    e3:SetCondition(c47522011.con)
    e3:SetTarget(c47522011.mdtg)
    e3:SetValue(c47522011.efilter)
    c:RegisterEffect(e3)
    --equip
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47522011,2))
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e4:SetCategory(CATEGORY_EQUIP)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c47522011.eqtg2)
    e4:SetOperation(c47522011.eqop2)
    c:RegisterEffect(e4) 
    --unequip
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47522011,3))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_FREE_CHAIN)
    e5:SetRange(LOCATION_SZONE)
    e5:SetTarget(c47522011.sptg)
    e5:SetOperation(c47522011.spop)
    c:RegisterEffect(e5)
    --ads
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_EQUIP)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetTarget(c47522011.target)
    e6:SetValue(c47522011.efilter2)
    c:RegisterEffect(e6)
    --spsummon bgm
    local e9=Effect.CreateEffect(c)
    e9:SetDescription(aux.Stringid(47522011,4))
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    e9:SetOperation(c47522011.spsuc)
    c:RegisterEffect(e9)
end
function c47522011.lcheck(g)
    return g:IsExists(Card.IsType,1,nil,TYPE_UNION)
end
function c47522011.spsuc(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_MUSIC,0,aux.Stringid(47522011,5))
end 
function c47522011.target(e,c)
    local te,g=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
    return not te or not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or not g or not g:IsContains(c)
end
function c47522011.efilter2(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c47522011.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47522011.filter(c)
    return c:IsType(TYPE_UNION) and c:IsAbleToHand() and c:IsLevelBelow(4)
end
function c47522011.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47522011.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c47522011.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47522011.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47522011.cfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c47522011.filter2(c)
    return c:IsType(TYPE_UNION) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c47522011.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c47522011.cfilter(chkc) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c47522011.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c47522011.filter2,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c47522011.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
end
function c47522011.eqop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local sg=Duel.SelectMatchingCard(tp,c47522011.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
    local sc=sg:GetFirst()
    if sc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
        if not Duel.Equip(tp,sc,tc,true) then return end
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c47522011.eqlimit)
        e1:SetLabelObject(tc)
        sc:RegisterEffect(e1)
    end
end
function c47522011.eqlimit(e,c)
    return e:GetLabelObject()==c
end
function c47522011.mdtg(e,c)
    return c:IsType(TYPE_UNION)
end
function c47522011.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c47522011.filter2(c)
    local ct1,ct2=c:GetUnionCount()
    return c:IsFaceup() and c:GetEquipCount()~=0 and c:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_UNION) and ct2==0
end
function c47522011.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47522011.filter2(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(47522011)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(c47522011.filter2,tp,LOCATION_MZONE,0,1,c) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c47522011.filter2,tp,LOCATION_MZONE,0,1,1,c)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
    c:RegisterFlagEffect(47522011,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47522011.eqop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    if not tc:IsRelateToEffect(e) or not c47522011.filter2(tc) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    if not Duel.Equip(tp,c,tc,false) then return end
    aux.SetUnionState(c)
end
function c47522011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:GetFlagEffect(47522011)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
    c:RegisterFlagEffect(47522011,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c47522011.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end