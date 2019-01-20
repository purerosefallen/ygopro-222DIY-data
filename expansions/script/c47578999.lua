--路西法的遗产 化身
function c47578999.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --activate
    local e0=Effect.CreateEffect(c)
    e0:SetDescription(aux.Stringid(47578999,0))
    e0:SetType(EFFECT_TYPE_FIELD)
    e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e0:SetCode(EFFECT_SPSUMMON_PROC)
    e0:SetRange(LOCATION_HAND)
    e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e0:SetValue(SUMMON_TYPE_RITUAL)
    e0:SetCondition(c47578999.spcon)
    e0:SetOperation(c47578999.spop)
    c:RegisterEffect(e0)  
    --destroy
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47578999,1))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c47578999.descon)
    e1:SetOperation(c47578999.desop)
    c:RegisterEffect(e1) 
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTarget(c47578999.target)
    e1:SetOperation(c47578999.activate)
    c:RegisterEffect(e1) 
end
function c47578999.mfilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsAbleToRemove()
end
function c47578999.mfilterf(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,12,rc)
    else return false end
end
function c47578999.spcon(e,c)    
    if c==nil then return true end
    if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
    local tp=c:GetControler()
    local mg=Duel.GetRitualMaterial(tp):Filter(Card.IsCanBeRitualMaterial,c,c)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if ft>0 then
        return mg:CheckWithSumGreater(Card.GetRitualLevel,12,c)
    else
        return mg:IsExists(c47578999.mfilterf,1,nil,tp,mg,c)
    end
end
function c47578999.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local c=e:GetHandler()
    local mg1=Duel.GetRitualMaterial(tp)
    local mg2=Duel.GetMatchingGroup(c47578999.mfilter,tp,LOCATION_GRAVE,0,nil)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    if c then
        local mg=mg1:Filter(Card.IsCanBeRitualMaterial,c,c)
        mg:Merge(mg2)
        local mat=nil
        if ft>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,12,c)
        else
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            mat=mg:FilterSelect(tp,c47578999.mfilterf,1,1,nil,tp,mg,c)
            Duel.SetSelectedCard(mat)
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
            local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,12,c)
            mat:Merge(mat2)
        end
        c:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
    end
end
function c47578999.descon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c47578999.rtgfilter(c)
    return c:GetOriginalType(TYPE_MONSTER) and c:GetOriginalType(TYPE_EFFECT)
end
function c47578999.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())
    if sg:GetCount()>0 then
        Duel.Remove(sg,POS_FACEUP,REASON_RULE) 
        local wg=sg:Filter(c47578999.rtgfilter,nil,tp)
        local wbc=wg:GetFirst()
        while wbc do
            local code=wbc:GetOriginalCode()
            if c:IsFaceup() and c:GetFlagEffect(code)==0 then
            c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
            c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)             
            end 
            wbc=wg:GetNext()
        end 
        local atk=wg:GetSum(Card.GetBaseAttack)
        local def=wg:GetSum(Card.GetBaseDefense)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_SET_BASE_ATTACK)
        e1:SetValue(atk)
        e1:SetReset(RESET_EVENT+0xff0000)
        c:RegisterEffect(e1) 
        local e2=e1:Clone()
        e2:SetCode(EFFECT_SET_BASE_DEFENSE)
        e2:SetValue(def)
        c:RegisterEffect(e2)
    end
end
function c47578999.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c47578999.activate(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end