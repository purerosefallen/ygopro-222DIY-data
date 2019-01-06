--世界的欺骗者 JOKER
function c47550014.initial_effect(c)
    --link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,4,c47550014.lcheck)
    c:EnableReviveLimit()   
    --cannot be destroyed
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e4=e1:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
    --immune
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetCode(EFFECT_IMMUNE_EFFECT)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetValue(c47550014.efilter)
    c:RegisterEffect(e5)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47550014,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCountLimit(1)
    e2:SetTarget(c47550014.destg)
    e2:SetOperation(c47550014.desop)
    c:RegisterEffect(e2) 
    --atk change
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47550014,2))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_ATTACK_ANNOUNCE)
    e3:SetCountLimit(1)
    e3:SetCondition(c47550014.atkcon)
    e3:SetTarget(c47550014.atktg)
    e3:SetOperation(c47550014.atkop)
    c:RegisterEffect(e3)
end
function c47550014.efilter(e,te)
    return te:IsHasCategory(CATEGORY_DESTROY)
end
function c47550014.lcheck(g,lc)
    return g:IsExists(c47550014.mzfilter,1,nil)
end
function c47550014.mzfilter(c)
    return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_LINK)
end
function c47550014.desfilter(c)
    return c:IsType(TYPE_MONSTER)
end
function c47550014.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c47550014.desfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c47550014.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c47550014.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
    if g:GetAttribute()==ATTRIBUTE_LIGHT then
        e:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
        e:SetLabel(1)
    else
        e:SetCategory(CATEGORY_DESTROY)
        e:SetLabel(0)
    end
    Duel.SetChainLimit(c47550014.limit(g:GetFirst()))
end
function c47550014.limit(c)
    return  function (e,lp,tp)
                return e:GetHandler()~=c
            end
end
function c47550014.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0
        and e:GetLabel()==1 and Duel.SelectYesNo(tp,aux.Stringid(47550014,1)) then
        Duel.BreakEffect()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
        local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
        if g:GetCount()>0 then
            Duel.HintSelection(g)
            Duel.SendtoGrave(g,REASON_EFFECT)
        end
    end
end
function c47550014.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetHandler():GetBattleTarget()
    local c=e:GetHandler()
    return tc and tc:IsFaceup() and tc:GetBaseAttack()>c:GetAttack()
end
function c47550014.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    Duel.SetTargetCard(e:GetHandler():GetBattleTarget())
    Duel.SetChainLimit(c47550014.chlimit)
end
function c47550014.chlimit(e,ep,tp)
    return tp==ep
end
function c47550014.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not c:IsRelateToEffect(e) or c:IsFacedown() or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
    if c:IsRelateToEffect(e) and c:IsFaceup() then
        local atk=tc:GetBaseAttack()
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_SET_ATTACK_FINAL)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        e2:SetValue(4000)
        c:RegisterEffect(e2,true)
        if tc:IsFaceup() and tc:IsRelateToEffect(e) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SET_ATTACK_FINAL)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            e1:SetValue(math.ceil(atk/2))
            tc:RegisterEffect(e1,true)
        end
    end
end