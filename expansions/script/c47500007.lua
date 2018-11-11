--暗杀者 姬塔
function c47500007.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --destroy and spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500007,1))
    e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,47500006)
    e1:SetTarget(c47500007.sptg)
    e1:SetOperation(c47500007.spop)
    c:RegisterEffect(e1)   
    --special summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,47500007)
    e2:SetCondition(c47500007.hspcon)
    e2:SetOperation(c47500007.hspop)
    c:RegisterEffect(e2) 
    --xyzrank8
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_XYZ_LEVEL)
    e3:SetValue(8)
    e3:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA)
    e3:SetTargetRange(LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
    c:RegisterEffect(e3)
    --copy
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47500007,2))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCountLimit(1,47500008)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTarget(c47500007.cytg)
    e4:SetOperation(c47500007.cyop)
    c:RegisterEffect(e4)
    --code
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_CHANGE_CODE)
    e5:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_EXTRA)
    e5:SetValue(47500000)
    c:RegisterEffect(e5)
end
c47500007.card_code_list={47500000}
function c47500007.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
    local m=_G["c"..c:GetCode()]
    local te=m.act_effect
    if not te then return false end
    local tg=te:GetTarget()
    return aux.IsCodeListed(c,47500000) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and (not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0))
end
function c47500007.cytg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingTarget(c47500007.efffilter,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c47500007.efffilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
    local m=_G["c"..g:GetFirst():GetCode()]
    local te=m.act_effect
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c47500007.cyop(e,tp,eg,ep,ev,re,r,rp,chk)
    local tc=Duel.GetFirstTarget()
    local m=_G["c"..tc:GetCode()]
    local te=m.act_effect
    if not te then return end
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c47500007.spfilter(c,e,tp)
    return (aux.IsCodeListed(c,47500000) or c:IsCode(47500000)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47500007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c47500007.setfilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c47500007.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
       if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) then
        local g=Duel.GetMatchingGroup(c47500007.setfilter,tp,LOCATION_DECK,0,nil)
            if g:GetCount()>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
            local sg=g:Select(tp,1,1,nil)
            Duel.SSet(tp,sg)
            Duel.ConfirmCards(1-tp,sg)
            end
        end
    end
end
function c47500007.tefilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsCode(47500000) and not c:IsForbidden()
end
function c47500007.hspcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    return ft>-1 and Duel.IsExistingMatchingCard(c47500007.tefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
end
function c47500007.hspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47500007,0))
    local g=Duel.SelectMatchingCard(tp,c47500007.tefilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoExtraP(g,tp,REASON_COST)
    end
end