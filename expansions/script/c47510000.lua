--生命的连接 露利亚
function c47510000.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,nil,2,2,c47510000.lcheck)
    c:EnableReviveLimit()    
    --extra link
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetTarget(c47510000.mattg)
    e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
    e0:SetTargetRange(LOCATION_HAND,0)
    e0:SetValue(c47510000.matval)
    c:RegisterEffect(e0)
    --apply effect
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47510000,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,47511000)
    e1:SetTarget(c47510000.efftg)
    e1:SetOperation(c47510000.effop)
    c:RegisterEffect(e1)
end
c47510000.is_named_with_Lyria=1
c47510000.card_code_list={47500000}
function c47510000.IsLyria(c)
    local m=_G["c"..c:GetCode()]
    return m and m.is_named_with_Lyria
end
function c47510000.filter1(c)
    return c47510000.IsLyria(c)
end
function c47510000.matval(e,c,mg)
    return c:IsCode(47510000)
end
function c47510000.mattg(e,c)
    return c:IsSetCard(0x5da) and c:IsType(TYPE_PENDULUM)
end
function c47510000.lcheck(g,lc)
    return g:IsExists(Card.IsLinkSetCard,1,nil,0x5da)
end
function c47510000.pscon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c47510000.psfilter(c)
    return c:IsCode(47500000)
end
function c47510000.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
        and Duel.IsExistingMatchingCard(c47510000.psfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c47510000.psop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47510000.psfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tc=g:GetFirst()
    local atk=tc:GetLeftScale()
    if g:GetCount()>0 then
        Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
    end
end
function c47510000.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
    local m=_G["c"..c:GetCode()]
    local te=m.ss_effect
    if not te then return false end
    local tg=te:GetTarget()
    return c:IsSetCard(0x5da) and c:IsType(TYPE_PENDULUM) and (not tg or tg and tg(e,tp,eg,ep,ev,re,r,rp,0))
end
function c47510000.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if chkc then return chkc:IsLocation(LOCATION_HAND+LOCATION_EXTRA) and chkc:IsControler(tp) and c47510000.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
    if chk==0 then return Duel.IsExistingTarget(c47510000.efffilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,eg,ep,ev,re,r,rp) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or zone>0) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,c47510000.efffilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    local m=_G["c"..g:GetFirst():GetCode()]
    local te=m.ss_effect
    local tg=te:GetTarget()
    if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c47510000.effop(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or zone<=0 then return end
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local zone=e:GetHandler():GetLinkedZone(tp)
        if zone~=0 and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
            local m=_G["c"..tc:GetCode()]
            local te=m.ss_effect
            if not te then return end
            local op=te:GetOperation()
            if op then op(e,tp,eg,ep,ev,re,r,rp) end
        end 
    end
end