--人偶少女 奥尔琪斯
function c47550007.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(1160)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND)
    e1:SetCost(c47550007.reg)
    c:RegisterEffect(e1)
    --to hand
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47550007,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCountLimit(1,47550007)
    e2:SetCondition(c47550007.thcon)
    e2:SetTarget(c47550007.thtg)
    e2:SetOperation(c47550007.thop)
    c:RegisterEffect(e2)
    --pendulum produce
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47550007,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_PZONE)
    e3:SetCountLimit(1,47550007)
    e3:SetTarget(c47550007.pentg)
    e3:SetOperation(c47550007.penop)
    c:RegisterEffect(e3) 
    --summon with 1 tribute
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(47550007,3))
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_SUMMON_PROC)
    e4:SetCondition(c47550007.otcon)
    e4:SetOperation(c47550007.otop)
    e4:SetValue(SUMMON_TYPE_ADVANCE)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(47550007,2))
    e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_SUMMON_PROC)
    e5:SetRange(LOCATION_HAND)
    e5:SetCondition(c47550007.ntcon)
    c:RegisterEffect(e5) 
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(47550007,4))
    e6:SetCategory(CATEGORY_EQUIP)
    e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_SUMMON_SUCCESS)
    e6:SetCountLimit(1,47550008)
    e6:SetRange(LOCATION_MZONE)
    e6:SetOperation(c47550007.eqop)
    c:RegisterEffect(e6) 
    local e7=e6:Clone()
    e7:SetCode(EVENT_ATTACK_ANNOUNCE)
    c:RegisterEffect(e7)
    --immune
    local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e8:SetRange(LOCATION_MZONE)
    e8:SetCode(EFFECT_UPDATE_ATTACK)
    e8:SetCondition(c47550007.eqcon)
    e8:SetValue(1000)
    c:RegisterEffect(e8)
    local e9=e8:Clone()
    e9:SetCode(EFFECT_EXTRA_ATTACK)
    e9:SetValue(1)
    c:RegisterEffect(e9)
    local e10=e9:Clone()
    e10:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    c:RegisterEffect(e10)
end
function c47550007.eqcon(e)
    local eg=e:GetHandler():GetEquipGroup()
    return eg:GetCount()>0
end
function c47550007.reg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:GetHandler():RegisterFlagEffect(47550007,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c47550007.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(47550007)~=0
end
function c47550007.thfilter(c)
    return c:IsLevelAbove(4) and c:IsSetCard(0x5d0) and c:IsAbleToHand()
end
function c47550007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47550007.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47550007.thop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c47550007.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c47550007.penfilter(c)
    return (c:IsLevelBelow(8) or c:IsRankBelow(8)) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFacedown()
end
function c47550007.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c47550007.penfilter,tp,LOCATION_EXTRA,0,1,nil)end
end
function c47550007.penop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
    local g=Duel.SelectMatchingCard(tp,c47550007.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    local c=e:GetHandler()
    if tc and Duel.Destroy(c,REASON_EFFECT)~=0 then
        Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
        e1:SetValue(LOCATION_DECK)
        tc:RegisterEffect(e1)
        local e3=Effect.CreateEffect(c)
        e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e3:SetCode(EVENT_PHASE+PHASE_END)
        e3:SetCountLimit(1)
        e3:SetLabel(fid)
        e3:SetLabelObject(tc)
        e3:SetCondition(c47550007.tdcon)
        e3:SetOperation(c47550007.tdop)
        Duel.RegisterEffect(e3,tp)
    end
end
function c47550007.tdcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    if tc:GetFlagEffectLabel(47550007)==e:GetLabel() then
        return true
    else
        e:Reset()
        return false
    end
end
function c47550007.tdop(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
end
function c47550007.otfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47550007.otcon(e,c,minc)
    if c==nil then return true end
    local mg=Duel.GetMatchingGroup(c47550007.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c47550007.otop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c47550007.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
    local sg=Duel.SelectTribute(tp,c,1,1,mg)
    c:SetMaterial(sg)
    Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47550007.ntcon(e,c,minc)
    if c==nil then return true end
    return minc==0 and c:IsLevelAbove(5)
        and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c47550007.tgfilter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler()
end
function c47550007.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.SelectMatchingCard(tp,c47550007.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
    local tc=g:GetFirst()
    if tc and c:IsFaceup() and tc:IsFaceup() then
        Duel.Equip(tp,tc,c,false)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
        e1:SetCode(EFFECT_EQUIP_LIMIT)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(c47550007.eqlimit)
        tc:RegisterEffect(e1)
    end
end
function c47550007.eqlimit(e,c)
    return e:GetOwner()==c
end
function c47550007.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsChainNegatable(ev)
end
function c47550007.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c47550007.operation(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
end