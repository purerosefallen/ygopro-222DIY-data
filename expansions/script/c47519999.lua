--红莲的破坏神 湿婆
function c47519999.initial_effect(c)
    c:EnableReviveLimit()
    aux.AddFusionProcFunRep(c,c47519999.ffilter,5,true)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47519999.psplimit)
    c:RegisterEffect(e1)
    --kaigan
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(c47519999.descon)
    e2:SetOperation(c47519999.desop)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e3:SetCondition(c47519999.rmcon)
    e3:SetTarget(c47519999.rmtg)
    e3:SetOperation(c47519999.rmop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetValue(1000)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetCode(EFFECT_PIERCE)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47519999.rmcon)
    e6:SetValue(c47519999.efilter)
    c:RegisterEffect(e6)
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e7:SetRange(LOCATION_MZONE)
    e7:SetValue(1)
    c:RegisterEffect(e7)
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e8:SetCondition(c47519999.damcon)
    e8:SetOperation(c47519999.damop)
    c:RegisterEffect(e8)    
end
function c47519999.ffilter(c,fc,sub,mg,sg)
    return c:IsFusionAttribute(ATTRIBUTE_FIRE) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c47519999.pefilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c47519999.psplimit(e,c,tp,sumtp,sumpos)
    return not c47519999.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47519999.cfilter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c47519999.descon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c47519999.cfilter,1,nil,tp)
end
function c47519999.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end
function c47519999.rmcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c47519999.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    if chk==0 then return g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
    Duel.SetChainLimit(aux.TRUE)
end
function c47519999.rmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)~=0 then
        local tc=g:GetFirst()
        for tc in aux.Next(g) do
            local e3=Effect.CreateEffect(c)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CANNOT_TRIGGER)
            e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
            e3:SetRange(LOCATION_REMOVED)
            e3:SetReset(RESET_EVENT+RESETS_STANDARD)
        end
    end
end
function c47519999.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c47519999.damcon(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c47519999.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end