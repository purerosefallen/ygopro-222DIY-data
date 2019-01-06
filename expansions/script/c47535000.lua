--究极合体 伟大勇者特急
function c47535000.initial_effect(c)
    c:SetUniqueOnField(1,0,47535000)
    --xyz summon
    aux.AddXyzProcedure(c,nil,12,5)
    c:EnableReviveLimit()
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47535000,0))
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetValue(SUMMON_TYPE_XYZ)
    e1:SetCondition(c47535000.spcon)
    e1:SetOperation(c47535000.spop)
    c:RegisterEffect(e1)  
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c47535000.xyzcon)
    e2:SetOperation(c47535000.xyzop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(c47535000.imcon)
    e3:SetValue(c47535000.efilter)
    c:RegisterEffect(e3)
    --dourinken
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47535000,1))
    e4:SetCategory(CATEGORY_TOGRAVE)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
    e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c47535000.tgcon)
    e4:SetTarget(c47535000.tgtg)
    e4:SetOperation(c47535000.tgop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c47535000.atkcon)
    e5:SetOperation(c47535000.atkop)
    c:RegisterEffect(e5)
    --disable
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_DISABLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetTargetRange(0,LOCATION_ONFIELD)
    e6:SetCondition(c47535000.discon)
    c:RegisterEffect(e6)
    local e7=e6:Clone()
    e7:SetCode(EFFECT_DISABLE_EFFECT)
    c:RegisterEffect(e7)
    --destroy
    local e8=Effect.CreateEffect(c)
    e8:SetDescription(aux.Stringid(47535000,2))
    e8:SetCategory(CATEGORY_DESTROY)
    e8:SetType(EFFECT_TYPE_IGNITION)
    e8:SetCountLimit(1)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47535000.descon)
    e8:SetTarget(c47535000.destg)
    e8:SetOperation(c47535000.desop)
    c:RegisterEffect(e8)
end
function c47535000.ovfilter(c,e)
    return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and not c:IsCode(c47535000)
end
function c47535000.refilter(c)
    return c:GetSequence()>=5
end
function c47535000.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47535000.ovfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,c)
    return g:IsExists(c47535000.ovfilter,1,nil,tp,g,c)
        and  g:GetClassCount(Card.GetCode)>2 and g:GetClassCount(Card.GetAttribute)>2 and Duel.IsExistingMatchingCard(c47535000.refilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47535000.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47535000.refilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Release(g,REASON_COST)
    Duel.RegisterFlagEffect(tp,47535000,RESET_PHASE+PHASE_END,0,1)
end
function c47535000.xyzcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFlagEffect(tp,47535000)~=0
end
function c47535000.mtfilter(c,e)
    return not c:IsImmuneToEffect(e)
end
function c47535000.xyzop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c47535000.ovfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,e:GetHandler())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local sg1=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local sg2=g:Select(tp,1,1,nil)
    g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local sg3=g:Select(tp,1,1,nil)
    if sg1:Merge(sg2)~=0 and sg1:Merge(sg3)~=0 then
    local tc=sg1:GetFirst()
        while tc do
            local mg=tc:GetOverlayGroup()
            if mg:GetCount()~=0 then
                Duel.Overlay(c,mg)
            end
            Duel.Overlay(c,Group.FromCards(tc))
            tc=sg1:GetNext()
        end
    end
end
function c47535000.imcon(e)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=2
end
function c47535000.efilter(e,te)
    return not te:GetOwner():IsRace(RACE_MACHINE) and not te:GetOwner():IsType(TYPE_XYZ)
end
function c47535000.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=3
end
function c47535000.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c47535000.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
    local tc=sg:GetFirst()
    if tc then
    local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
        if cg:GetCount()>0 then
            Duel.SendtoGrave(cg,REASON_RULE) 
       end
    end
end
function c47535000.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=4
end
function c47535000.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetAttackTarget()
    if not tc then return end
    if tc:IsControler(tp) then tc=Duel.GetAttacker() end
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EFFECT_SET_ATTACK_FINAL)
        e1:SetValue(0)
        e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetRange(LOCATION_MZONE)
        e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
        e2:SetValue(0)
        e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
        tc:RegisterEffect(e2,true)
end
function c47535000.discon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=5
end
function c47535000.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():GetClassCount(Card.GetCode)>=6
end
function c47535000.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c47535000.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,LOCATION_REMOVED,REASON_EFFECT)
end