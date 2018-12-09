--姬塔 Re:Link
function c47500019.initial_effect(c)
    --link summon
    c:EnableReviveLimit()
    aux.AddLinkProcedure(c,c47500019.lfilter,2,2)
    --relink
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(47500019,1))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,47500019+EFFECT_COUNT_CODE_OATH)
    e1:SetCost(c47500019.cost)
    e1:SetOperation(c47500019.operation)
    c:RegisterEffect(e1)
    --fudu
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(47500019,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,47500018+EFFECT_COUNT_CODE_OATH)
    e2:SetCost(c47500019.cpcost)
    e2:SetOperation(c47500019.cpop)
    c:RegisterEffect(e2)  
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(47500019,2))
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCode(EFFECT_SPSUMMON_PROC)
    e3:SetRange(LOCATION_EXTRA)
    e3:SetCondition(c47500019.sprcon)
    e3:SetOperation(c47500019.sprop)
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_EXTRA,0)
    e4:SetCondition(c47500019.rlcon)
    e4:SetTarget(c47500019.mattg)
    e4:SetLabelObject(e3)
    c:RegisterEffect(e4)   
    --code
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_CHANGE_CODE)
    e5:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
    e5:SetValue(47500000)
    c:RegisterEffect(e5)
end
c47500019.card_code_list={47500000}
function c47500019.lfilter(c)
    return c:GetOriginalCode()==47500000
end
function c47500019.cfilter(c)
    return aux.IsCodeListed(c,47500000) and c:IsAbleToGraveAsCost()
end
function c47500019.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c47500019.cfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c47500019.cfilter,tp,LOCATION_DECK,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_COST)
    local tc=g:GetFirst()
    e:SetLabel(tc:GetOriginalCode())
end
function c47500019.cpop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local code=e:GetLabel()
    c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
end
function c47500019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end
    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c47500019.filter(c)
    return c:IsSpecialSummonable(SUMMON_TYPE_LINK) and c:IsCode(47500019)
end
function c47500019.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c47500019.filter,tp,LOCATION_EXTRA,0,1,1,nil)
    local tc=g:GetFirst()
    if tc and Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_LINK)~=0 then
        tc:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(47500019,3))
        tc:RegisterFlagEffect(47500019,RESET_EVENT+0x7e0000,0,1)
    end
end
function c47500019.rlcon(e)
    return e:GetHandler():GetFlagEffect(47500019)>0
end
function c47500019.cfilter1(c)
    return (aux.IsCodeListed(c,47500000) or c:GetOriginalCode()==47500000) and c:IsReleasable()
end
function c47500019.spfilter1(c,tp,g)
    return g:IsExists(c47500019.spfilter2,1,c,tp,c)
end
function c47500019.spfilter2(c,tp,mc)
    return (aux.IsCodeListed(c,47500000) and mc:GetOriginalCode()==47500000 and c:GetOriginalType()==TYPE_MONSTER 
        or c:GetOriginalCode()==47500000 and aux.IsCodeListed(mc,47500000) and mc:GetOriginalType()==TYPE_MONSTER)
        and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c47500019.sprcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local g=Duel.GetMatchingGroup(c47500019.cfilter1,tp,LOCATION_ONFIELD,0,nil)
    return g:IsExists(c47500019.spfilter1,1,nil,tp,g)
end
function c47500019.sprop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.GetMatchingGroup(c47500019.cfilter1,tp,LOCATION_ONFIELD,0,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g1=g:FilterSelect(tp,c47500019.spfilter1,1,1,nil,tp,g)
    local mc=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g2=g:FilterSelect(tp,c47500019.spfilter2,1,1,mc,tp,mc)
    g1:Merge(g2)
    local cg=g1:Filter(Card.IsFacedown,nil)
    if cg:GetCount()>0 then
        Duel.ConfirmCards(1-tp,cg)
    end
    Duel.Release(g1,REASON_COST)
end
function c47500019.mattg(e,c)
    return aux.IsCodeListed(c,47500000) and c:IsType(TYPE_PENDULUM)
end