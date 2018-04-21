--现世的赤龙唤士 索妮娅
local m=60159906
local cm=_G["c"..m]
function cm.initial_effect(c)
    cm.AddLinkProcedure(c,function(c)
        return c:GetSummonLocation()&(LOCATION_DECK+LOCATION_EXTRA)~=0 and c:IsAttribute(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
    end,4,4,function(g)
        local att=0
        for tc in aux.Next(g) do
            att=att|tc:GetAttribute()
        end
        return att&(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)==(ATTRIBUTE_EARTH+ATTRIBUTE_FIRE+ATTRIBUTE_WATER+ATTRIBUTE_WIND)
    end)
    c:EnableReviveLimit()
    --spsummon condition
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(cm.linklimit)
    c:RegisterEffect(e1)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(cm.con)
    e3:SetTarget(cm.tg)
    e3:SetOperation(cm.op)
    c:RegisterEffect(e3)
end
function cm.linklimit(e,se,sp,st)
    return bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.filter(c)
    return c:IsAbleToDeck()
end
function cm.filter2(c)
    return not (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsAttribute(ATTRIBUTE_WATER) 
        or c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WIND)) and c:IsType(TYPE_MONSTER) 
        and c:IsAbleToRemove()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,e:GetHandler())
    local g2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
    Duel.SetChainLimit(aux.FALSE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_HAND,e:GetHandler())
    if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then Duel.BreakEffect()
        local g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0)
        local g2=Duel.GetFieldGroup(tp,0,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
        Duel.ConfirmCards(1-tp,g1)
        Duel.ConfirmCards(tp,g2)
        local g3=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,nil)
        Duel.Remove(g3,POS_FACEDOWN,REASON_EFFECT)
        Duel.ShuffleDeck(tp)
        Duel.ShuffleDeck(1-tp)
        Duel.ShuffleHand(tp)
        Duel.ShuffleHand(1-tp)
    end
end
function cm.AddLinkProcedure(c,f,min,max,gf)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetRange(LOCATION_EXTRA)
    if max==nil then max=c:GetLink() end
    e1:SetCondition(cm.LinkCondition(f,min,max,gf))
    e1:SetTarget(cm.LinkTarget(f,min,max,gf))
    e1:SetOperation(Auxiliary.LinkOperation(f,min,max,gf))
    e1:SetValue(SUMMON_TYPE_LINK)
    c:RegisterEffect(e1)
end
function cm.LinkCondition(f,minc,maxc,gf)
    return  function(e,c)
                if c==nil then return true end
                if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
                local tp=c:GetControler()
                local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,f,c)
                local sg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
                if sg:IsExists(Auxiliary.MustMaterialCounterFilter,1,nil,mg) then return false end
                local ct=sg:GetCount()
                if ct>maxc then return false end
                return Auxiliary.LCheckGoal(tp,sg,c,minc,ct,gf)
                    or mg:IsExists(Auxiliary.LCheckRecursive,1,sg,tp,sg,mg,c,ct,minc,maxc,gf)
            end
end
function cm.LinkTarget(f,minc,maxc,gf)
    return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
                local mg=Duel.GetMatchingGroup(Auxiliary.LConditionFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,f,c)
                local bg=Auxiliary.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
                if #bg>0 then
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
                    bg:Select(tp,#bg,#bg,nil)
                end
                local sg=Group.CreateGroup()
                sg:Merge(bg)
                while #sg<maxc do
                    local cg=mg:Filter(Auxiliary.LCheckRecursive,sg,tp,sg,mg,c,#sg,minc,maxc,gf)
                    if #cg==0 then break end
                    local finish=Auxiliary.LCheckGoal(tp,sg,c,minc,#sg,gf)
                    local cancel=(#sg==0 or finish)
                    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
                    local tc=cg:SelectUnselect(sg,tp,finish,cancel,minc,maxc)
                    if not tc then break end
                    if not bg:IsContains(tc) then
                        if not sg:IsContains(tc) then
                            sg:AddCard(tc)
                        else
                            sg:RemoveCard(tc)
                        end
                    elseif #bg>0 and #sg<=#bg then
                        return false
                    end
                end
                if #sg>0 then
                    sg:KeepAlive()
                    e:SetLabelObject(sg)
                    return true
                else return false end
            end
end