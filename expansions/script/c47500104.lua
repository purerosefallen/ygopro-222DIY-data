--大魔导师 姬塔
function c47500104.initial_effect(c)
    --material
    c:EnableReviveLimit() 
    aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_PENDULUM),8,2)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47500104.psplimit)
    c:RegisterEffect(e1)
    --cheisa
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47500104)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetOperation(c47500104.csop)
    c:RegisterEffect(e2)   
    --damage
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_BATTLED)
    e3:SetCondition(c47500104.damcon)
    e3:SetOperation(c47500104.damop)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)
    --element blast
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47500104,0))
    e5:SetType(EFFECT_TYPE_QUICK_O)
    e5:SetCode(EVENT_CHAINING)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c47500104.chcon)
    e5:SetCost(c47500104.cost)
    e5:SetOperation(c47500104.chop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_SPSUMMON_SUCCESS)
    e6:SetCondition(c47500104.sumcon)
    e6:SetOperation(c47500104.sumsuc)
    c:RegisterEffect(e6)
end
c47500104.pendulum_level=8
c47500104.card_code_list={47500000}
function c47500104.mfilter(c,xyzc)
    return c:IsLevel(8) and c:IsRace(RACE_SPELLCASTER)
end
function c47500104.pefilter(c)
    return c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_SPELLCASTER)
end
function c47500104.psplimit(e,c,tp,sumtp,sumpos)
    return not c47500104.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47500104.csop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_ATTACK_ALL)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetValue(1)
    Duel.RegisterEffect(e1,tp)
end
function c47500104.damcon(e)
    return e:GetHandler():GetBattleTarget()~=nil
end
function c47500104.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Damage(1-tp,1100,REASON_EFFECT)
end
function c47500104.chcon(e,tp,eg,ep,ev,re,r,rp)
    return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,47500000)
end
function c47500104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c47500104.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c47500104.repop)
end
function c47500104.repop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
        c:CancelToGrave(false)
    end
    Duel.Damage(tp,1000,REASON_EFFECT)
end
function c47500104.sumcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c47500104.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_IMMUNE_EFFECT)
        e1:SetValue(c47500104.efilter)
        e1:SetOwnerPlayer(tp)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
end
function c47500104.efilter(e,re)
    return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end