--天女 姬塔
function c47501010.initial_effect(c)
    --synchro summon
    aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,47500000),aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),1,1)
    c:EnableReviveLimit()    
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_SYNCHRO)
    e0:SetCondition(c47501010.sprcon)
    e0:SetOperation(c47501010.sprop)
    c:RegisterEffect(e0) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501010.psplimit)
    c:RegisterEffect(e1) 
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_PZONE)
    e2:SetOperation(c47501010.chainop)
    c:RegisterEffect(e2)   
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_PZONE)
    e3:SetTargetRange(0,1)
    e3:SetOperation(c47501010.damop)
    c:RegisterEffect(e3)   
    --salvage
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47501010,0))
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_SPSUMMON_SUCCESS)
    e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e5:SetCountLimit(1,47501910)
    e5:SetCondition(c47501010.thcon)
    e5:SetTarget(c47501010.thtg)
    e5:SetOperation(c47501010.thop)
    c:RegisterEffect(e5)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e7:SetCode(EVENT_BE_BATTLE_TARGET)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCondition(c47501010.fcon)
    e7:SetOperation(c47501010.fop1)
    c:RegisterEffect(e7)
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_BECOME_TARGET)
    e9:SetRange(LOCATION_MZONE)
    e9:SetCondition(c47501010.fcon)
    e9:SetTarget(c47501010.ftg)
    e9:SetOperation(c47501010.fop2)
    c:RegisterEffect(e9)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_FIELD)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCondition(c47501010.fcon1)
    e8:SetValue(2000)
    e8:SetTargetRange(LOCATION_MZONE,0)
    c:RegisterEffect(e8)
end
c47501010.card_code_list={47500000}
function c47501010.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501010.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501010.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501010.fusfilter1(c)
    return c:GetOriginalCode()==47500000
end
function c47501010.cfilter(c)
    return (c:IsCode(47500000) or c:GetOriginalCode()==47500000) and c:IsCanBeSynchroMaterial() and c:IsReleasable()
end
function c47501010.spfilter1(c,tp,g)
    return g:IsExists(c47501010.spfilter2,1,c,tp,c)
end
function c47501010.spfilter2(c,tp,mc)
    return (c:GetOriginalCode()==47500000 and mc:IsCode(47500000)
        or c:IsCode(47500000) and mc:GetOriginalCode()==47500000)
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47501010.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47501010.cfilter,tp,LOCATION_MZONE,0,nil)
    return g:IsExists(c47501010.spfilter1,1,nil,tp,g)
end
function c47501010.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47501010.cfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47501010.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47501010.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_SYNCHRO)
end
function c47501010.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function c47501010.chainop(e,tp,eg,ep,ev,re,r,rp)
    if re:IsHasCategory(CATEGORY_DAMAGE) and ep==tp then
        Duel.SetChainLimit(c47501010.chainlm)
    end
end
function c47501010.chainlm(e,rp,tp)
    return tp==rp
end
function c47501010.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c47501010.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47501010.penfiltert,tp,LOCATION_EXTRA,0,1,nil) end
end
function c47501010.penfiltert(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and c:IsFaceup()
end
function c47501010.thop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectMatchingCard(tp,c47501010.penfiltert,tp,LOCATION_EXTRA,0,2,2,nil)
    local tc=g:GetFirst()
    while tc do
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
        tc=g:GetNext()
    end
    local c=e:GetHandler()
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47501010,2))
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_EXTRA_PENDULUM_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetValue(c47501010.pendvalue)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)  
end
function c47501010.pendvalue(e,c)
    return aux.IsCodeListed(c,47500000)
end
function c47501010.fcon(e)
    return e:GetHandler():GetFlagEffect(47501010)<1
end
function c47501010.fcon1(e)
    return e:GetHandler():GetFlagEffect(47501010)==1
end
function c47501010.fop1(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateAttack() then
    c:RegisterFlagEffect(47501010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end
function c47501010.ftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c47501010.fop2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if Duel.NegateEffect(ev) then
    c:RegisterFlagEffect(47501010,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end