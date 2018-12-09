--剑豪 姬塔
function c47501011.initial_effect(c)
    aux.EnablePendulumAttribute(c,false)
    --fusion material
    c:EnableReviveLimit()
    aux.AddFusionProcCodeFun(c,c47501011.fusfilter1,aux.FilterBoolFunction(Card.IsCode,47500000),1,true,true)
    --special summon rule
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetRange(LOCATION_EXTRA)
    e0:SetValue(SUMMON_TYPE_FUSION)
    e0:SetCondition(c47501011.sprcon)
    e0:SetOperation(c47501011.sprop)
    c:RegisterEffect(e0)   
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47501011.psplimit)
    c:RegisterEffect(e1) 
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47501011,1))
    e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47501011)
    e2:SetTarget(c47501011.damtg)
    e2:SetOperation(c47501011.damop)
    c:RegisterEffect(e2)  
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_ADJUST)
    e3:SetRange(LOCATION_MZONE)
    e3:SetOperation(c47501011.efop)
    c:RegisterEffect(e3) 
    --ta
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c47501011.inmcon)
    e4:SetValue(2)
    c:RegisterEffect(e4)
end
c47501011.card_code_list={47500000}
function c47501011.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47501011.psplimit(e,c,tp,sumtp,sumpos)
    return not c47501011.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47501011.fusfilter1(c)
    return c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c47501011.cfilter(c)
    return (c:IsCode(47500000) or (c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_WATER)))
        and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable()
end
function c47501011.spfilter1(c,tp,g)
    return g:IsExists(c47501011.spfilter2,1,c,tp,c)
end
function c47501011.spfilter2(c,tp,mc)
    return (c:IsRace(RACE_WARRIOR) and mc:IsCode(47500000) and c:IsAttribute(ATTRIBUTE_WATER)
        or c:IsCode(47500000) and mc:IsRace(RACE_WARRIOR) and mc:IsAttribute(ATTRIBUTE_WATER))
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47501011.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47501011.cfilter,tp,LOCATION_MZONE,0,nil)
    return g:IsExists(c47501011.spfilter1,1,nil,tp,g) and c:IsFacedown()
end
function c47501011.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47501011.cfilter,tp,LOCATION_MZONE,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47501011.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47501011.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c47501011.damfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c47501011.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_PZONE) and c47501011.damfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47501011.damfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c47501011.damfilter,tp,LOCATION_MZONE+LOCATION_PZONE,LOCATION_MZONE+LOCATION_PZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c47501011.damop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc=Duel.GetFirstTarget()
    local c=e:GetHandler()
    local atk=c:GetTextAttack()
    if tc:IsRelateToEffect(e) and Duel.Damage(1-tp,atk,REASON_EFFECT) then
        Duel.Destroy(c,REASON_EFFECT)
    end
end
function c47501011.rtgfilter(c)
    return aux.IsCodeListed(c,47500000)
end
function c47501011.efop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then return end
    local c=e:GetHandler()  
    local eq=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
    local wg=eq:Filter(c47501011.rtgfilter,nil,tp)
    local wbc=wg:GetFirst()
    while wbc do
        local code=wbc:GetOriginalCode()
        if c:IsFaceup() and c:GetFlagEffect(code)==0 then
        c:CopyEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
        c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)  
        end 
        wbc=wg:GetNext()
    end  
end
function c47501011.inmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end