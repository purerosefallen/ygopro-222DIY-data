--冒险启程的圣炎天彩夏
local m=4212205
local cm=_G["c"..m]
function cm.initial_effect(c)
        iFunc(c).c("RegisterEffect",iFunc(c)
        .e("SetCategory",CATEGORY_NEGATE+CATEGORY_DESTROY)
        .e("SetType",EFFECT_TYPE_QUICK_O)
        .e("SetCode",EVENT_CHAINING)
        .e("SetRange",LOCATION_HAND)
        .e("SetCondition",function(e,tp,eg,ep,ev,re,r,rp)
            return tp~=ep and Duel.GetCurrentChain()==0 end)
        .e("SetCost",function(e,tp,eg,ep,ev,re,r,rp,chk)
            local c=e:GetHandler()
            if chk==0 then return c:IsAbleToGraveAsCost() 
                and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,c)end
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
                local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,c) 
                g:AddCard(c) Duel.SendtoGrave(g,REASON_COST) end)
        .e("SetTarget",function(e,tp,eg,ep,ev,re,r,rp,chk)
            if chk==0 then return true end
            Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
            if Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil) then
                Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
            end end)
        .e("SetOperation",function(e,tp,eg,ep,ev,re,r,rp)
            if Duel.NegateSummon(eg) and Duel.Destroy(eg,REASON_EFFECT) and re:GetHandler():IsRelateToEffect(re) then
                if Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) then
                    if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
                        local g = Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
                        Duel.SendtoHand(g,nil,REASON_EFFECT) 
                        Duel.ConfirmCards(1-tp,g) 
                    end
                end
            end end)
    .Return())
end
function cm.mfilter(c)
    return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_SPELLCASTER) and c:IsFaceup()
end
function cm.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.costfilter(c)
    return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function iFunc(c,x)
    local __this = (aux.GetValueType(c) == "Card" and {(x == nil and {Effect.CreateEffect(c)} or {x})[1]} or {x})[1] 
    local fe = function(name,...) (type(__this[name])=="function" and {__this[name]} or {""})[1](__this,...) return iFunc(c,__this) end
    local fc = function(name,...) this = (type(c[name])=="function" and {c[name]} or {""})[1](c,...) return iFunc(c,c) end  
    local func ={e = fe,c = fc,g = fc,v = function() return this end,Return = function() return __this:Clone() end}
    return func
end