--无颜者
function c22200161.initial_effect(c)
	c:EnableReviveLimit()
	c22200161.AddLinkProcedureUseFaceDownMonseters(c,nil,1,1)
	--Guess
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22200161,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,22200161)
	e1:SetTarget(c22200161.target)
	e1:SetOperation(c22200161.operation)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(22200161,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CUSTOM+22200161)
	e2:SetCondition(c22200161.thcon)
	e2:SetTarget(c22200161.thtg)
	e2:SetOperation(c22200161.thop)
	c:RegisterEffect(e2)
end
function c22200161.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
end
function c22200161.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) then return false end
	local tc=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.SelectOption(1-tp,70,71,72)
	Duel.ConfirmCards(1-tp,tc)
	if (op~=0 and tc:IsType(TYPE_MONSTER)) or (op~=1 and tc:IsType(TYPE_SPELL)) or (op~=2 and tc:IsType(TYPE_TRAP)) then
		if not c:IsRelateToEffect(e) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetLabel(op)
		e1:SetCondition(c22200161.discon)
		e1:SetOperation(c22200161.disop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1,true)
	else
		Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
	end
	Duel.ShuffleHand(tp)
end
function c22200161.discon(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if rp==tp then return false end
	if op==0 then
		return re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_SPELL)
	elseif op==1 then
		return re:IsActiveType(TYPE_TRAP) or re:IsActiveType(TYPE_MONSTER)
	elseif op==2 then
		return re:IsActiveType(TYPE_MONSTER) or re:IsActiveType(TYPE_SPELL)
	end
end
function c22200161.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateEffect(ev) then 
		Duel.Hint(HINT_CARD,0,22200161)
		Duel.RaiseEvent(c,EVENT_CUSTOM+22200161,e,0,tp,0,0)
	end
	e:Reset()
end
function c22200161.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c22200161.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) end
end
function c22200161.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=c:GetLinkedGroup()
	if chk==0 then return tg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,tg:GetCount(),0,0)
end
function c22200161.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=c:GetLinkedGroup()
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end
--Link Summon
function c22200161.AddLinkProcedureUseFaceDownMonseters(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c22200161.LinkCondition(f,min,max,gf))
	e1:SetOperation(c22200161.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function c22200161.LConditionFilter(c,f,lc)
	return c:IsFacedown() and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function c22200161.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else
		return 1 
	end
end
function c22200161.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:AddCard(c)
	ct=ct+1
	local res=c22200161.LCheckGoal(tp,sg,lc,minc,ct,gf)
		or (ct<maxc and mg:IsExists(c22200161.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c22200161.LCheckGoal(tp,sg,lc,minc,ct,gf)
	return ct>=minc and sg:CheckWithSumEqual(c22200161.GetLinkCount,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
end
function c22200161.LinkCondition(f,minc,maxc,gf)
	if Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL) then return false end
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFacedown() then return false end
				local tp=c:GetControler()
				local mg=Duel.GetMatchingGroup(c22200161.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local sg=Group.CreateGroup()
				return mg:IsExists(c22200161.LCheckRecursive,1,nil,tp,sg,mg,c,0,minc,maxc,gf)
			end
end
function c22200161.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local mg=Duel.GetMatchingGroup(c22200161.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,c)
				local sg=Group.CreateGroup()
				for i=0,maxc-1 do
					local cg=mg:Filter(c22200161.LCheckRecursive,sg,tp,sg,mg,c,i,minc,maxc,gf)
					if cg:GetCount()==0 then break end
					local minct=1
					if c22200161.LCheckGoal(tp,sg,c,minc,i,gf) then
						if not Duel.SelectYesNo(tp,210) then break end
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local g=cg:Select(tp,minct,1,nil)
					if g:GetCount()==0 then break end
					sg:Merge(g)
				end
				c:SetMaterial(sg)
				Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
			end
end
function c22200161.IsMaterialListCode(c,code)
	if not c.material then return false end
	for i,mcode in ipairs(c.material) do
		if code==mcode then return true end
	end
	return false
end
function c22200161.IsMaterialListSetCard(c,setcode)
	return c.material_setcode and c.material_setcode==setcode
end
function c22200161.IsCodeListed(c,code)
	if not c.card_code_list then return false end
	for i,ccode in ipairs(c.card_code_list) do
		if code==ccode then return true end
	end
	return false
end