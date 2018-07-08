--莱姆狐-机云雾
local m=1130601
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Hinbackc=true
--
function c1130601.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c1130601.LinkCondition(c1130601.cfilter1,1,1))
	e1:SetTarget(c1130601.LinkTarget(c1130601.cfilter1,1,1))
	e1:SetOperation(c1130601.LinkOperation(c1130601.cfilter1,1,1))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2,true)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1130601,0))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1130601.tg3)
	e3:SetOperation(c1130601.op3)
	c:RegisterEffect(e3)
--
end
--
function c1130601.cfilter1(c)
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
		or (c:IsCode(1131005) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()))
end
--
function c1130601.LConditionFilter(c,f,lc)
	return (c:IsCanBeLinkMaterial(lc) or c:IsLocation(LOCATION_GRAVE)) and (not f or f(c))
end
--
function c1130601.GetLinkMaterials(tp,f,lc)
	local mg=Duel.GetMatchingGroup(c1130601.LConditionFilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil,f,lc)
	local mg2=Duel.GetMatchingGroup(aux.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
--
function c1130601.LCheckGoal(tp,sg,lc,minc,ct,gf)
	return ct>=minc 
		and sg:CheckWithSumEqual(aux.GetLinkCount,lc:GetLink(),ct,ct) 
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 
		and (not gf or gf(sg))
		and not sg:IsExists(aux.LUncompatibilityFilter,1,nil,sg,lc)
end
--
function c1130601.LCheckRecursive(c,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:AddCard(c)
	ct=ct+1
	local res=c1130601.LCheckGoal(tp,sg,lc,minc,ct,gf)
		or ct<maxc and mg:IsExists(c1130601.LCheckRecursive,1,sg,tp,sg,mg,lc,ct,minc,maxc,gf)
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
--
function c1130601.LinkCondition(f,minc,maxc,gf)
	return  
	function(e,c)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local mg=c1130601.GetLinkMaterials(tp,f,c)
		local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
		local ct=sg:GetCount()
		if ct>maxc then return false end
		return c1130601.LCheckGoal(tp,sg,c,minc,ct,gf)
			or mg:IsExists(c1130601.LCheckRecursive,1,sg,tp,sg,mg,c,ct,minc,maxc,gf)
	end
end
--
function c1130601.LinkTarget(f,minc,maxc,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
		local mg=c1130601.GetLinkMaterials(tp,f,c)
		local bg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
		if #bg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			bg:Select(tp,#bg,#bg,nil)
		end
		local sg=Group.CreateGroup()
		sg:Merge(bg)
		local finish=false
		while #sg<maxc do
			finish=c1130601.LCheckGoal(tp,sg,c,minc,#sg,gf)
			local cg=mg:Filter(c1130601.LCheckRecursive,sg,tp,sg,mg,c,#sg,minc,maxc,gf)
			if #cg==0 then break end
			local cancel=not finish
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local tc=cg:SelectUnselect(sg,tp,finish,cancel,minc,maxc)
			if not tc then break end
			if not bg:IsContains(tc) then
				if not sg:IsContains(tc) then
					sg:AddCard(tc)
					if #sg==maxc then finish=true end
				else
					sg:RemoveCard(tc)
				end
			elseif #bg>0 and #sg<=#bg then
				return false
			end
		end
		if finish then
			sg:KeepAlive()
			e:SetLabelObject(sg)
			return true
		else return false end
	end
end
--
function c1130601.lfilter(c)
	return c:IsCode(1131005) and c:IsLocation(LOCATION_GRAVE)
end
function c1130601.LinkOperation(f,min,max,gf)
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
		local g=e:GetLabelObject()
		c:SetMaterial(g)
		local sg=g:Filter(c1130601.lfilter,nil)
		if sg:GetCount()>0 then 
			g:Sub(sg)
			Duel.Remove(sg,POS_FACEUP,REASON_COST)
		end
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
		g:DeleteGroup()
	end
end
--
function c1130601.tfilter3_1(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c1130601.tfilter3_2(c,g)
	return c:IsFaceup() and g:IsContains(c)
end
function c1130601.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local tg=Group.CreateGroup()
	local lg=Duel.GetMatchingGroup(c1130601.tfilter3_1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		tg:Merge(tc:GetLinkedGroup())
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1130601.tfilter3_2(chkc,tg,tp) end
	if chk==0 then return Duel.IsExistingTarget(c1130601.tfilter3_2,tp,0,LOCATION_MZONE,1,nil,tg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1130601.tfilter3_2,tp,0,LOCATION_MZONE,1,7,nil,tg)
end
--
function c1130601.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	while sc do
--
		local e3_3=Effect.CreateEffect(c)
		e3_3:SetType(EFFECT_TYPE_SINGLE)
		e3_3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3_3:SetValue(1)
		e3_3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		sc:RegisterEffect(e3_3)
		local e3_4=Effect.CreateEffect(c)
		e3_4:SetType(EFFECT_TYPE_SINGLE)
		e3_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e3_4:SetValue(1)
		e3_4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		sc:RegisterEffect(e3_4)
		local e3_5=Effect.CreateEffect(c)
		e3_5:SetType(EFFECT_TYPE_SINGLE)
		e3_5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e3_5:SetValue(1)
		e3_5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		sc:RegisterEffect(e3_5)
		local e3_6=Effect.CreateEffect(c)
		e3_6:SetType(EFFECT_TYPE_SINGLE)
		e3_6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3_6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3_6:SetValue(1)
		e3_6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		sc:RegisterEffect(e3_6)
--
		local e3_7=Effect.CreateEffect(c)
		e3_7:SetType(EFFECT_TYPE_SINGLE)
		e3_7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3_7:SetRange(LOCATION_MZONE)
		e3_7:SetCode(EFFECT_IMMUNE_EFFECT)
		e3_7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e3_7:SetValue(c1130601.efilter3_7)
		sc:RegisterEffect(e3_7)
--
		sc=sg:GetNext()
	end
end
--
function c1130601.efilter3_7(e,te)
	return te:GetOwner()~=e:GetOwner() and e:GetHandler()~=te:GetOwner()
end
--
