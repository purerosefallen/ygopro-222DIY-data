--炼金工作室-测试卡
local m=4212320
local cm=_G["c"..m]
--増援
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,cm)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.cache={}
function cm.filter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsAbleToHand() and cm.CheckDiscard(c,e,tp,eg,ep,ev,re,r,rp)and not (c:IsCode(e:GetHandler():GetCode())) 
end
function cm.CheckDiscard(c,e,tp,eg,ep,ev,re,r,rp)
	local code=c:GetOriginalCode()
	if cm.cache[code] then return cm.cache[code]==1 end
	local eset={}
	local temp=Card.RegisterEffect
	Card.RegisterEffect=function(tc,te,f)
		if (te:GetRange()&LOCATION_HAND)>0 and te:IsHasType(0x7e0) then
			table.insert(eset,te:Clone())
		end
		return temp(tc,te,f)
	end
	local tempc=cm.IgnoreActionCheck(Duel.CreateToken,c:GetControler(),code)
	Card.RegisterEffect=temp
	local found=false
	for _,te in ipairs(eset) do
		local cost=te:GetCost()
		if cost then
			local mt=getmetatable(tempc)
			local temp_=Effect.GetHandler
			Effect.GetHandler=function(e)
				if e==te then return tempc end
				return temp_(e)
			end
			mt.IsDiscardable=function(tc,...)
				if tempc==tc then found=true end
				return Card.IsDiscardable(tc,...)
			end
			pcall(function()
				cost(te,tp,eg,ep,ev,re,r,rp,0)
			end)
			mt.IsDiscardable=nil
			Effect.GetHandler=temp_
		end
	end
	cm.cache[code]=(found and 1 or 0)
	return found
end
function cm.IgnoreActionCheck(f,...)
	Duel.DisableActionCheck(true)
	local cr=coroutine.create(f)
	local ret={}
	while coroutine.status(cr)~="dead" do
		local sret={coroutine.resume(cr,...)}
		for i=2,#sret do
			table.insert(ret,sret[i])
		end
	end
	Duel.DisableActionCheck(false)
	return table.unpack(ret)
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end