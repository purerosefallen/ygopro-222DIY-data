--巧克力小姐 茧墨阿座化
function c22260145.initial_effect(c)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetValue(c22260145.splimit)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    c:RegisterEffect(e1)
    --special summon rule
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_SPSUMMON_PROC)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e2:SetRange(LOCATION_EXTRA)
    e2:SetCondition(c22260145.spcon)
    e2:SetOperation(c22260145.spop)
    c:RegisterEffect(e2)
    --immune
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_IMMUNE_EFFECT)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(LOCATION_ONFIELD,0)
    e3:SetTarget(c22260145.tg)
    e3:SetValue(c22260145.efilter)
    c:RegisterEffect(e3)
    --Token
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(22260145,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c22260145.tkcon)
    e2:SetTarget(c22260145.tktg)
    e2:SetOperation(c22260145.tkop)
    c:RegisterEffect(e2)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(22260145,2))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_GRAVE)
    e1:SetCost(c22260145.cost)
    e1:SetTarget(c22260145.target)
    e1:SetOperation(c22260145.operation)
    c:RegisterEffect(e1)
end
c22260145.named_with_MayuAzaka=1
c22260145.Desc_Contain_MayuAzaka=1
function c22260145.IsMayuAzaka(c)
    local m=_G["c"..c:GetCode()]
    return m and m.named_with_MayuAzaka
end
function c22260145.splimit(e,se,sp,st)
    return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c22260145.confilter(c)
    return c:IsReleasable() and c:GetLevel()>0
end
function c22260145.gcheck(g,tp,fc)
    return Duel.GetLocationCountFromEx(tp,tp,g,fc)>0 and g:GetSum(Card.GetLevel)==12
end
function c22260145.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    local mg=Duel.GetMatchingGroup(c22260145.confilter,tp,LOCATION_MZONE,0,nil)
    return c22260145.CheckGroup(mg,c22260145.gcheck,nil,1,12,tp,c)
end
function c22260145.spop(e,tp,eg,ep,ev,re,r,rp,c)
    local mg=Duel.GetMatchingGroup(c22260145.confilter,tp,LOCATION_MZONE,0,nil)
    local g=c22260145.SelectGroup(tp,HINTMSG_RELEASE,mg,c22260145.gcheck,nil,1,12,tp,c)
    Duel.Release(g,REASON_COST)
end
function c22260145.tg(e,c)
    return c:IsCode(22269998)
end
function c22260145.efilter(e,te)
    return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c22260145.tkcon(e,tp,eg,ep,ev,re,r,rp)
    return rp~=tp
end
function c22260145.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) and Duel.GetMZoneCount(tp)>0 end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c22260145.tkop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetMZoneCount(tp)<1 or not Duel.IsPlayerCanSpecialSummonMonster(tp,22269998,nil,0x4011,0,0,11,RACE_FAIRY,ATTRIBUTE_DARK) then return end
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local token=Duel.CreateToken(tp,22269998)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function c22260145.costfilter(c)
    return c:IsCode(22269998) and c:IsReleasable()
end
function c22260145.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetMZoneCount(tp)
    if chk==0 then
        if ft<0 then return false end
        if ft==0 then
            return Duel.IsExistingMatchingCard(c22260145.costfilter,tp,LOCATION_MZONE,0,1,nil)
        else
            return Duel.IsExistingMatchingCard(c22260145.costfilter,tp,LOCATION_ONFIELD,0,1,nil)
        end
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    if ft==0 then
        local g=Duel.SelectMatchingCard(tp,c22260145.costfilter,tp,LOCATION_MZONE,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_COST)
    else
        local g=Duel.SelectMatchingCard(tp,c22260145.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
        Duel.SendtoHand(g,nil,REASON_COST)
    end
end
function c22260145.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function c22260145.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
        e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e1:SetReset(RESET_EVENT+0xfe0000)
        e1:SetValue(LOCATION_REMOVED)
        c:RegisterEffect(e1)
    end
end
------------------------------------------------------------------
function c22260145.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
    sg:AddCard(c)
    local res=(#sg>=min and #sg<=max and f(sg,table.unpack(ext_params)))
        or (#sg<max and g:IsExists(c22260145.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
    sg:RemoveCard(c)
    return res
end
function c22260145.CheckGroup(g,f,cg,min,max,...)
    local min=min or 1
    local max=max or #g
    if min>max then return false end
    local ext_params={...}
    local sg=Group.CreateGroup()
    if cg then sg:Merge(cg) end
    if #sg>=min and #sg<=max and f(sg,...) then return true end
    return g:IsExists(c22260145.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function c22260145.SelectGroup(tp,desc,g,f,cg,min,max,...)
    local min=min or 1
    local max=max or #g
    local ext_params={...}
    local sg=Group.CreateGroup()
    local cg=cg or Group.CreateGroup()
    sg:Merge(cg)
    local ag=g:Filter(c22260145.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)  
    while #sg<max and #ag>0 do
        local finish=(#sg>=min and #sg<=max and f(sg,...))
        local seg=sg-cg
        local dmin=#seg
        local dmax=math.min(max-#cg,#g)
        Duel.Hint(HINT_SELECTMSG,tp,desc)
        local tc=ag:SelectUnselect(seg,tp,finish,finish,dmin,dmax)
        if not tc then break end
        if sg:IsContains(tc) then
            sg:RemoveCard(tc)
        else
            sg:AddCard(tc)
        end
        ag=g:Filter(c22260145.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
    end
    return sg
end
function c22260145.SelectGroupWithCancel(tp,desc,g,f,cg,min,max,...)
    local min=min or 1
    local max=max or #g
    local ext_params={...}
    local sg=Group.CreateGroup()
    local cg=cg or Group.CreateGroup()
    sg:Merge(cg)
    local ag=g:Filter(c22260145.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)  
    while #sg<max and #ag>0 do
        local finish=(#sg>=min and #sg<=max and f(sg,...))
        local cancel=finish or #sg==0
        local seg=sg-cg
        local dmin=#seg
        local dmax=math.min(max-#cg,#g)
        Duel.Hint(HINT_SELECTMSG,tp,desc)
        local tc=ag:SelectUnselect(seg,tp,finish,cancel,dmin,dmax)
        if not tc then
            if not finish then return end
            break
        end
        if sg:IsContains(tc) then
            sg:RemoveCard(tc)
        else
            sg:AddCard(tc)
        end
        ag=g:Filter(c22260145.CheckGroupRecursive,sg,sg,g,f,min,max,ext_params)
    end
    return sg
end