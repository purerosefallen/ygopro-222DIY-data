--冥界的地狱犬 刻耳柏洛斯
function c47510307.initial_effect(c)
    --revive limit
    aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND+LOCATION_EXTRA)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
    --special summon condition
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e0) 
    --splimit
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c47510307.psplimit)
    c:RegisterEffect(e1)  
    --extra attack
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47510307,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47510307)
    e2:SetCondition(c47510307.condition)
    e2:SetCost(c47510307.eacost)
    e2:SetTarget(c47510307.eatg)
    e2:SetOperation(c47510307.eaop)
    c:RegisterEffect(e2) 
    --special summon
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e3:SetRange(LOCATION_HAND+LOCATION_EXTRA)
    e3:SetCondition(c47510307.spcon)
    e3:SetOperation(c47510307.spop)
    c:RegisterEffect(e3)   
    --destroy
    local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
    e4:SetCode(EVENT_SPSUMMON_SUCCESS)
    e4:SetOperation(c47510307.eqop)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_EXTRA_ATTACK)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c47510307.atkval)
    c:RegisterEffect(e5) 
    --damage
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47510307,1))
    e6:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e6:SetCode(EVENT_PHASE+PHASE_BATTLE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c47510307.dacon)
    e6:SetOperation(c47510307.daop)
    c:RegisterEffect(e6)
    --sunmoneffect
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_EXTRA)
    e7:SetCountLimit(1,47510000)
    e7:SetCost(c47510307.coscost)
    e7:SetOperation(c47510307.cosop)
    c:RegisterEffect(e7)
    c47510307.ss_effect=e7
end
function c47510307.pefilter(c)
    return c:IsRace(RACE_FIEND) or c:IsSetCard(0x5da) or c:IsAttribute(ATTRIBUTE_DARK)
end
function c47510307.psplimit(e,c,tp,sumtp,sumpos)
    return not c47510307.pefilter(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47510307.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsAbleToEnterBP()
end
function c47510307.eafilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c47510307.eacost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47510307.eafilter,tp,LOCATION_EXTRA,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp,c47578916.cfilter,tp,LOCATION_EXTRA,0,3,3,nil)
    Duel.SendtoGrave(g,REASON_COST)
end
function c47510307.eafilter(c)
    return c:IsFaceup()
end
function c47510307.eatg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47510307.eafilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47510307.eafilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c47510307.eafilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47510307.eaop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_EXTRA_ATTACK)
        e1:SetValue(2)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c47510307.ftarget)
    e2:SetLabel(tc:GetFieldID())
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c47510307.ftarget(e,c)
    return e:GetLabel()~=c:GetFieldID()
end
function c47510307.rfilter(c,tp)
    return c:IsLevelAbove(6) and c:IsType(TYPE_PENDULUM) and (c:IsControler(tp) or c:IsFaceup())
end
function c47510307.mzfilter(c,tp)
    return c:IsControler(tp) and c:GetSequence()<5
end
function c47510307.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510307.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft+1
    return ft>-2 and rg:GetCount()>1 and (ft>0 or rg:IsExists(c47510307.mzfilter,ct,nil,tp))
end
function c47510307.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local rg=Duel.GetReleaseGroup(tp):Filter(c47510307.rfilter,nil,tp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local g=nil
    if ft>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:Select(tp,2,2,nil)
    elseif ft==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510307.mzfilter,1,1,nil,tp)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local g2=rg:Select(tp,1,1,g:GetFirst())
        g:Merge(g2)
    else
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        g=rg:FilterSelect(tp,c47510307.mzfilter,2,2,nil,tp)
    end
    Duel.Release(g,REASON_COST)
end
function c47510307.eqfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47510307.eqop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_EXTRA,LOCATION_EXTRA,nil)
    if Duel.SendtoGrave(g,REASON_EFFECT) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
        local g=Duel.SelectMatchingCard(tp,c47510307.eqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
        local c=e:GetHandler()
        local tc=g:GetFirst()
        for tc in aux.Next(g) do
            Duel.Equip(tp,tc,c,false)
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
            e1:SetCode(EFFECT_EQUIP_LIMIT)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD)
            e1:SetValue(c47510307.eqlimit)
            tc:RegisterEffect(e1)
        end
   end
end
function c47510307.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47510307.atkval(e,c)
    return c:GetEquipCount()
end
function c47510307.dacon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0
end
function c47510307.dafilter(c,rc)
    return c:IsFaceup() and bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0
end
function c47510307.daop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c47510307.dafilter,1,1,nil,tp)
    local tc=g:GetFirst()
    local atk=tc:GetBaseAttack()
    Duel.SendtoGrave(g,REASON_COST)
    Duel.Damage(1-tp,atk,REASON_EFFECT)
end
function c47510307.cosfilter(c)
    return c:IsType(TYPE_XYZ) and c:IsFacedown()
end
function c47510307.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and  Duel.IsExistingMatchingCard(c47510307.cosfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,c47510307.cosfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
    Duel.ConfirmCards(1-tp,g)
    Duel.SetTargetCard(g:GetFirst())
end
function c47510307.cosop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    local att=tc:GetAttribute()
    local race=tc:GetRace()
    local code=tc:GetCode()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_ADD_CODE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5da))
    e1:SetValue(code)
    Duel.RegisterEffect(e1,tp)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_ADD_ATTRIBUTE)
    e2:SetValue(att)
    Duel.RegisterEffect(e2,tp)
    local e3=e1:Clone()
    e3:SetCode(EFFECT_ADD_RACE)
    e3:SetValue(race)
    Duel.RegisterEffect(e3,tp)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetTarget(c47510307.splimit0)
    e4:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e4,tp)
end
function c47510307.splimit0(e,c)
    return not c:IsType(TYPE_XYZ) and c:IsLocation(LOCATION_EXTRA)
end
